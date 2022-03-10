
{ system ? builtins.currentSystem, ... }:

let
  # As NIX_PATH is tightly controlled,
  # using <> import is not breaking hermeticity.
  pkgs = import <nixpkgs> {
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
