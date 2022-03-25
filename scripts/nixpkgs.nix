with builtins;
let
  flake = (import
    (
      let lock = fromJSON (builtins.readFile ../flake.lock); in
      fetchTarball {
        url = "https://github.com/edolstra/flake-compat/archive/${lock.nodes.flake-compat.locked.rev}.tar.gz";
        sha256 = lock.nodes.flake-compat.locked.narHash;
      }
    )
    { src = ../.; }
  ).defaultNix;
  flakeNixPaths =
    if (hasAttr "nixPaths" flake.outputs)
    then flake.outputs.nixPaths
    else { };
  inputPaths = flake.inputs // flakeNixPaths;
  pathInputs = mapAttrs (k: v: "${v}") inputPaths;
  paths = pathInputs;
in
builtins.concatStringsSep ":" (builtins.attrValues (builtins.mapAttrs (k: v: "${k}=${v}") paths))
