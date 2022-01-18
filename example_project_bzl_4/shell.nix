
{ system ? builtins.currentSystem, ... }:

let
  flakes-lock = builtins.fromJSON (builtins.readFile ../flake.lock);
  pkgs-manifest = flakes-lock.nodes.nixpkgs.locked;
  pkgs-source = builtins.fetchTarball {
    url =
      "https://github.com/${pkgs-manifest.owner}/${pkgs-manifest.repo}/archive/${pkgs-manifest.rev}.tar.gz";
    sha256 =
      (builtins.replaceStrings [ "sha256-" ] [ "" ] pkgs-manifest.narHash);
  };
  pkgs = import pkgs-source {
    inherit system;
  };
in pkgs.stdenv.mkDerivation {
  name = "example-project-bzl-4-shell";
  buildInputs = with pkgs; [
    cacert
    coreutils-full
    curlFull
    direnv
    gnutar
    nixUnstable
    bazel_4
    bazel-buildtools
  ];
  shellHook = ''
    export TERM=xterm
    # readlink as absolute path is needed
    echo "startup --output_base $(readlink -f ./bazel-output)" > "$(pwd)"/.output-bazelrc
  '';
  TMPDIR = "/tmp";
}
