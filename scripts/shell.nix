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
    shellcheck
  ];

  TERM = "xterm";
  TMPDIR = "/tmp";

  shellHook = ''
    set -a; . ${builtins.getEnv "NIX_SHELL_RC"}; set +a
    cat ${pkgs.nix-direnv}/share/nix-direnv/direnvrc > ''${DIRENV_CONFIG}/direnvrc
    eval "$(direnv hook bash)"
    cd() { builtin cd $1; eval "$(direnv export bash)"; }
  '';
}

