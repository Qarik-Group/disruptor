{ pkgs ? import <nixpkgs> { } }:
with builtins;
let
  PWD = getEnv "PWD";
  setIfEmpty = name: default:
    if getEnv name == ""
    then default
    else getEnv name;

in
pkgs.mkShell {
  buildInputs = with pkgs; [
    cacert
    coreutils-full
    curlFull
    direnv
    # Add git client to shell, it reads host configuration
    git
    gnutar
    # Nix 2.5 (as the one from the installator)
    nixUnstable
    # Dynamically load nix envs
    nix-direnv
    shellcheck
  ];


  # nix-shell --keep will refuse to retain a variable,
  # which is not exported in user shell, but which is
  # set in the nix-shell.sh.
  # Working around this issue takes a lot of effort
  # (detecting export, exporting and undoing exports
  # on shell closure).
  # This approach is more naive, but less
  # maintainance intensive.
  DIRENV_CONFIG = setIfEmpty "DIRENV_CONFIG" "${PWD}/.cache";
  NIX_CONF_DIR = setIfEmpty "NIX_CONF_DIR" "${PWD}/scripts";
  NIX_PATH = setIfEmpty "NIX_PATH" "nixpkgs=${PWD}/scripts/nixpkgs.nix";
  NIX_USER_CONF_FILES = "";
  TERM = "xterm";
  TMPDIR = "/tmp";

  shellHook = ''
    . ${pkgs.nix-direnv}/share/nix-direnv/direnvrc
    eval "$(direnv hook bash)"
    cd() { builtin cd $1; eval "$(direnv export bash)"; }
  '';
}

