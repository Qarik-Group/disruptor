#!/usr/bin/env sh
fail() {
  echo "$0:" "$@" >&2
  exit 1
}

# Nicked from https://releases.nixos.org/nix/nix-2.5.1/install
require_util() {
  command -v "$1" > /dev/null 2>&1 ||
    fail "you do not have '$1' installed, which I need to $2"
}

if [ "$1" != "--wrapped" ]; then
  require_util curl "download dependencies"
  require_util base64 "decode dependencies"

  WD="$(mktemp -d)"
  mkdir -p "${WD}/bin"
  mkdir -p "${WD}/lib64"

  case "$(uname)" in
    Darwin)
      curl -L -s\
        'https://github.com/robxu9/bash-static/releases/download/5.1.016-1.2.2/bash-macos-x86_64'\
        -o "${WD}/bin/bash"

      curl -L -s\
        'https://android.googlesource.com/platform/prebuilts/build-tools/+/refs/heads/master/darwin-x86/bin/toybox?format=TEXT'\
        -o - | base64 -d - > "${WD}/bin/toybox"

      curl -L -s\
        'https://android.googlesource.com/platform/prebuilts/build-tools/+/refs/heads/master/darwin-x86/lib64/libz-host.dylib?format=TEXT'\
        -o - | base64 -d - > "${WD}/lib64/libz-host.dylib"

      curl -L -s\
        'https://android.googlesource.com/platform/prebuilts/build-tools/+/refs/heads/master/darwin-x86/lib64/libcrypto-host.dylib?format=TEXT'\
        -o - | base64 -d - > "${WD}/lib64/libcrypto-host.dylib"
    ;;
    *)
     curl -L -s\
       'https://github.com/robxu9/bash-static/releases/download/5.1.016-1.2.2/bash-linux-x86_64'\
       -o "${WD}/bin/bash"

     curl -L -s\
       'http://landley.net/toybox/downloads/binaries/0.8.6/toybox-x86_64'\
       -o "${WD}/bin/toybox"
    ;;
  esac

  chmod +x "${WD}/bin/bash" && chmod +x "${WD}/bin/toybox"

  for i in $("${WD}/bin/toybox"); do
    [ "${i}" == "bash" ] && continue
    "${WD}/bin/toybox" ln -s "${WD}/bin/toybox" "${WD}/bin/${i}";
  done

  # symlink host utils
  for i in curl nix nix-shell; do
    if existing_bin="$("${WD}/bin/which" "${i}" 2>/dev/null)" && [ -n "${existing_bin}" ]; then
      "${WD}/bin/ln" -s "${existing_bin}" "${WD}/bin/${i}"
    fi
  done

  DEFAULT_PATH="${PATH}" PATH="${WD}/bin" bash -- "$0" --wrapped "$@"

  rm -rf "${WD}"
  exit
fi

#!${WD}/bin/bash
shift

# Assumption #1: non-GNU, non-BSD linux distros are out-of-scope
# Otherwise we at least need to get rid of 'local' keyword
# Assumption #2: coreutils are present in $PATH
# Assumption #3: there is internet access (assumption to be removed)

set -eu -o pipefail

# Find current script location
{
  # Double quoting breaks desired behaviour
  # shellcheck disable=SC2086
  __DIR__=$(dirname "$(readlink -f $0)")
} || {
  echo "Unable to determine current script location.."
  echo "Will assume '.'"
  __DIR__="."
}


readonly USER_HOME="${HOME:-"HOME variable has not been set"}"
readonly DEFAULT_NIX_PATH="nixpkgs=${__DIR__}/nixpkgs.nix"
readonly CACHE_ROOT="${__DIR__}/../.cache"
readonly NIX_USER_CHROOT_VERSION="1.2.2"
readonly NIX_USER_CHROOT_DIR="${CACHE_ROOT}/nix-user-chroot"
readonly NIX_USER_CHROOT_BIN="${NIX_USER_CHROOT_DIR}/nix-user-chroot"
readonly NIX_STORE="${CACHE_ROOT}/nix-store"
readonly NIX_VERSION="2.5.1"
readonly NIX_INSTALL_SCRIPT="${CACHE_ROOT}/nix-${NIX_VERSION}-install.sh"
readonly NIX_CONF_DIR="${__DIR__}"
readonly NIX_USER_CONF_FILES=''
readonly DIRENV_CONFIG="${CACHE_ROOT}"
readonly DIRENV_CONF_PATH="${DIRENV_CONFIG}/direnv.toml"
readonly NIX_SHELL_RC="${CACHE_ROOT}/nix_shell.rc"

EXTRA_RC=''
IS_NIX_INSTALLED=false
VANILLA_RUN=false

# Check if running on NixOS
if [ -e "/etc/os-release" ]; then
  case "$(cat /etc/os-release)" in 
    *NixOS*)
      readonly IS_NIXOS=true;
    ;;
    *)
      readonly IS_NIXOS=false;
    ;;
  esac
else
  readonly IS_NIXOS=false;
fi

preflightCheck() {
  case "$(uname)" in
    Darwin)
      require_util nix "make the magic happen. You are running on OSX, please make sure Nix is installed by running the following: sh <(curl -L https://nixos.org/nix/install)."
    ;;
    Linux)
      require_util unshare "verify kernel support for user namespaces"
    ;;
    *)
      echo "Platform not yet supported"
    ;;
  esac
}

printHelp() {
  cat << EOF
   Usage: nix-shell.sh [--rcfile] [--vanilla] [--help] -- <PARAMS TO PASS TO NIX-SHELL>

   optional arguments:
     -h, --help                        print this message and exit
     -r extra.rc, --rcfile=extra.rc    load additional rc file when entering shell
     -v, --vanilla                     drop user in to plain bash shell, with default nix setup
                                       (global channel, impure).
EOF
}

setup_nix_user_chroot() {
  # Verify that user namespaces for unprivileged users are enabled
  local readonly are_user_ns_enabled
  are_user_ns_enabled="$(unshare\
   --user --pid echo -n YES \
  )"
  if [ "${are_user_ns_enabled}" != "YES" ]; then
    # TODO: Implement fallback to proot
    fail "Current kernel settings do not allow\
     running user namespaces for unprivileged users."
  fi

  local readonly arch
  arch=$(uname -m)
  case "${arch}" in
    "aarch64")
    local readonly download_url="https://github.com/nix-community\
/nix-user-chroot/releases/download/${NIX_USER_CHROOT_VERSION}\
/nix-user-chroot-bin-${NIX_USER_CHROOT_VERSION}-aarch64-unknown-linux-musl"
    ;;
    "x86_64")
    local readonly download_url="https://github.com/nix-community\
/nix-user-chroot/releases/download/${NIX_USER_CHROOT_VERSION}\
/nix-user-chroot-bin-${NIX_USER_CHROOT_VERSION}-x86_64-unknown-linux-musl"
    ;;
    *)
    fail "Arch '${arch}' is not supported at the moment."
    ;;
  esac

  mkdir -p "${NIX_USER_CHROOT_DIR}" || {
    fail "Unable to create '${NIX_USER_CHROOT_DIR}'"
  }
  curl -L -o "${NIX_USER_CHROOT_BIN}" "${download_url}" || {
    fail "Unable to download nix-user-chroot (url: ${download_url})"
  }
  chmod +x "${NIX_USER_CHROOT_BIN}"
}

setup_nix() {
  mkdir -p "${NIX_STORE}" || {
    fail "Unable to create '${NIX_STORE}'"
  }
  # shellcheck disable=SC2250
  $NIX_USER_CHROOT_BIN "${NIX_STORE}" sh -c\
   "curl -L https://releases.nixos.org/nix/nix-${NIX_VERSION}/install > ${NIX_INSTALL_SCRIPT} && sh ${NIX_INSTALL_SCRIPT}\
    --no-channel-add\
    --no-daemon\
    --no-modify-profile\
    --nix-extra-conf-file ${NIX_CONF_DIR}/nix.conf"
}

ensure_direnv_is_configured() {
  local readonly project_root
  project_root=$(dirname "$(readlink -f "${__DIR__}"/..)")
  mkdir -p "${CACHE_ROOT}"
  cat > "${DIRENV_CONF_PATH}" << EOF
[whitelist]
prefix = [ "${project_root}" ]
EOF
}

ensure_nix_is_present() {
  if ${IS_NIXOS}; then
    # On nixos, nix is installed by default
    return
  fi

  if command -v "nix" >/dev/null 2>&1; then
    IS_NIX_INSTALLED=true;
  else
    IS_NIX_INSTALLED=false;
  fi
  # We need to distinguish between single-user and multi-user installs.
  # This is difficult because there's no official way to do this.
  # Details: https://github.com/lilyball/nix-env.fish/blob/00c6cc762427efe08ac0bd0d1b1d12048d3ca727/conf.d/nix-env.fish

  # stat is not portable. Splitting the output of ls -nd is reliable on most platforms.
  if ${IS_NIX_INSTALLED}; then
    if [ "$(stat -c %u /nix)" -eq 0 ]; then
      local readonly is_nix_multiuser_install=true;
    else
      local readonly is_nix_multiuser_install=false;
    fi
  else
    # shellcheck disable=SC2034
    local readonly is_nix_multiuser_install=false;
  fi

  # Global, single-user installation
  if ${IS_NIX_INSTALLED} && ! ${is_nix_multiuser_install}; then
    return
  fi

  if ${IS_NIX_INSTALLED} && ${is_nix_multiuser_install}; then
    # TODO: Find a solution
    fail "Daemon-based nix installation is not supported"
  fi

  if [ -d "${NIX_STORE}" ]; then
    # Nix has already been set up
    echo "Detected previous setup in ${CACHE_ROOT}. Will attempt to use it."
    return
  fi

  # No nix installed or nix is multi-user installation
  setup_nix_user_chroot
  setup_nix
}

ensure_nix_shell_rc_exists() {
  if ${VANILLA_RUN}; then

    set +u
    if
      # shellcheck disable=SC1090
      [ -n "${EXTRA_RC}" ]\
      && nix_path_in_rc="$(. "${EXTRA_RC}"; echo "${NIX_PATH}")"\
      && [ -n "${nix_path_in_rc}" ];
    then
      local nix_path="${nix_path_in_rc}"
    elif
      [ -n "${NIX_PATH}" ];
    then
      local nix_path="${NIX_PATH}"
    else
      fail "NIX_PATH undefined"
    fi
    set -u

  else
    local nix_path="${DEFAULT_NIX_PATH}"
  fi

  mkdir -p "${CACHE_ROOT}"

  if [ -n "${EXTRA_RC}" ]; then cat "${EXTRA_RC}" >> "${NIX_SHELL_RC}"; fi

  if ! ${IS_NIXOS} || ${IS_NIX_INSTALLED}; then
     cat >> "${NIX_SHELL_RC}" <<-EOL
	. ${USER_HOME}/.nix-profile/etc/profile.d/nix.sh
	NIX_CONF_DIR=${NIX_CONF_DIR}
	NIX_USER_CONF_FILES=${NIX_USER_CONF_FILES}
	EOL
  fi

  cat >> "${NIX_SHELL_RC}" <<- EOL
	DIRENV_CONFIG=${DIRENV_CONFIG}
	NIX_SHELL_RC=${NIX_SHELL_RC}
	NIX_PATH=${nix_path}
	EOL

}

preflightCheck

needs_arg() { if [ -z "$OPTARG" ]; then fail "No arg for --$OPT option"; fi; }

while getopts hr:v-: OPT; do
  # support long options: https://stackoverflow.com/a/28466267/519360
  if [ "$OPT" = "-" ]; then   # long option: reformulate OPT and OPTARG
    OPT="${OPTARG%%=*}"       # extract long option name
    OPTARG="${OPTARG#$OPT}"   # extract long option argument (may be empty)
    OPTARG="${OPTARG#=}"      # if long option argument, remove assigning `=`
  fi
  case "$OPT" in
    h | help )     printHelp && exit ;;
    v | vanilla )  VANILLA_RUN=true ;;
    r | rcfile )   needs_arg; EXTRA_RC="$(readlink -f "$OPTARG")" ;;
    ??* )          die "Illegal option --$OPT" ;;  # bad long option
    ? )            exit 2 ;;  # bad short option (error reported via getopts)
  esac
done
shift $((OPTIND-1)) # remove parsed options and args from $@ list

ensure_nix_is_present
ensure_direnv_is_configured
ensure_nix_shell_rc_exists

# shellcheck disable=SC1091
. "${__DIR__}/push.sh"

if ! ${IS_NIXOS} && ! ${IS_NIX_INSTALLED}; then
  # shellcheck disable=SC2250
  SHELL="$NIX_USER_CHROOT_BIN ${NIX_STORE} bash"
fi

# Pass arguments to nix-shell preserving quotes
if ${VANILLA_RUN}; then
  Push -c nsargs "$@" || true
else
  Push -c nsargs --pure "$@"
fi

# shellcheck disable=SC2086,SC2154
PATH="${DEFAULT_PATH}" exec ${SHELL}\
  -ci "\
  set -a ; . ${NIX_SHELL_RC}; set +a ;\
  nix-shell '${__DIR__}/shell.nix' ${nsargs}"

