#! /usr/bin/env nix-shell
#! nix-shell -i bash -p coreutils

# Find current script location
{
  __FILE__=$(dirname "$(realpath $0)")
} || {
  echo "Unable to determine current script location.."
  echo "Will assume '.'"
  __FILE__="."
}

NIX_DEPS_FILE="${__FILE__}/bzl/nix-file-deps.bzl"

cd "${__FILE__}"
echo 'NIX_FILE_DEPS = [' > "${NIX_DEPS_FILE}"
# TODO: Harden against whitespaces in dir/file names
for f in $(find . -type f -printf '@distruptor_nix//:%P\n'); do
  echo "    \"${f}\"," >> "${NIX_DEPS_FILE}"
done
echo "]" >> "${NIX_DEPS_FILE}"
