{ disruptor, pkgs, lib, ... }:

pkgs.stdenv.mkDerivation {
  name = "xz.bzl";
  buildInputs = [
    pkgs.xz
    pkgs.xz.dev
  ];

  phases = [
    "installPhase"
  ];

  installPhase = ''
    mkdir $out
    cp ${disruptor.bazelHelpers.createCppBuildFile "xz"} $out/BUILD.bazel
    cp -R ${pkgs.xz}/* $out/
    cp -R ${pkgs.xz.dev}/include $out/
  '';
}
