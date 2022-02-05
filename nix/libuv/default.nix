{ disruptor, pkgs, lib, ... }:

pkgs.stdenv.mkDerivation {
  name = "libuv.bzl";
  buildInputs = [
    pkgs.libuv
  ];

  phases = [
    "installPhase"
  ];

  installPhase = ''
    mkdir $out
    cp ${disruptor.bazelHelpers.createCppBuildFile "libuv"} $out/BUILD.bazel
    cp -R ${pkgs.libuv}/* $out/
  '';
}
