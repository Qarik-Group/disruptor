{ pkgs ? import <nixpkgs> { } }:
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
    act
    docker
  ];

  TERM = "xterm";
  TMPDIR = "/tmp";

  shellHook = ''
    set -a; . ${builtins.getEnv "NIX_SHELL_RC"}; set +a
    . ${pkgs.nix-direnv}/share/nix-direnv/direnvrc
    eval "$(direnv hook bash)"
    cd() { builtin cd $1; eval "$(direnv export bash)"; }
  '';
}

