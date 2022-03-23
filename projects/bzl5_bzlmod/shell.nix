
{ system ? builtins.currentSystem, ... }:

let
  # As NIX_PATH is tightly controlled,
  # using <> import is not breaking hermeticity.
  pkgs = import <nixpkgs> {
    inherit system;
  };
  pkgs_unstable = import (fetchTarball https://nixos.org/channels/nixos-unstable/nixexprs.tar.xz) { };
in pkgs.stdenv.mkDerivation {
  name = "bzl-5-shell";
  buildInputs = with pkgs; [
    cacert
    coreutils-full
    curlFull
    direnv
    gnutar
    nixUnstable
    pkgs_unstable.bazel_5
    pkgs_unstable.bazel-buildtools
  ];
  shellHook = ''
    export TERM=xterm
    # readlink as absolute path is needed
    echo "startup --output_base $(readlink -f ./bazel-output)" > "$(pwd)"/.output-bazelrc
  '';
  TMPDIR = "/tmp";
}
