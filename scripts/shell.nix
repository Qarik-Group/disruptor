{ vanilla ? false }:
with builtins;
let
  flake = (import
    (
      let lock = fromJSON (readFile ../flake.lock); in
      fetchTarball {
        url = "https://github.com/edolstra/flake-compat/archive/${lock.nodes.flake-compat.locked.rev}.tar.gz";
        sha256 = lock.nodes.flake-compat.locked.narHash;
      }
    )
    { src = ../.; }
  ).defaultNix;

  NIX_PATH =
    if vanilla
    then getEnv "NIX_PATH"
    else
      concatStringsSep ":" (
        attrValues (
          mapAttrs
            (
              n: v:
                if hasAttr "path" v
                then "${n}=${storePath v.path}"
                else "${n}=null"
            )
            (
              (mapAttrs (n: v: getAttr currentSystem v) flake.outputs)
            )
        )
      );

  pkgs =
    if vanilla
    then (import <nixpkgs> flake.outputs.callArgs.${currentSystem})
    else flake.outputs.nixpkgs.${currentSystem};

  # nixgl = flake.outputs.nixgl.${currentSystem};

in
pkgs.mkShell {
  inherit NIX_PATH;
  TERM = "xterm";
  TMPDIR = "/tmp";

  buildInputs = with pkgs; [
    cacert
    coreutils-full
    curlFull
    direnv
    # Add git client to shell, it reads host configuration
    git
    gnutar
    nix
    shellcheck
  ] ++ (
    # nigGL works only on x86_64-linux
    if builtins.currentSystem == "x86_64-linux" then [ 
      nixgl.nixGLIntel
      nixgl.nixVulkanIntel 
    ] else []
  );

  shellHook = ''
    set -a; . ${getEnv "NIX_SHELL_RC"}; set +a
    cat ${pkgs.nix-direnv}/share/nix-direnv/direnvrc > ''${DIRENV_CONFIG}/direnvrc
    eval "$(direnv hook bash)"
    cd() { builtin cd $1; eval "$(direnv export bash)"; }
  '';
}

