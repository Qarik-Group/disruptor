{ disruptor, pkgs, lib, ... }:

pkgs.stdenv.mkDerivation {
  name = "xorg.libX11.bzl";
  buildInputs = [
    pkgs.xorg.libX11
    pkgs.xorg.libX11.dev
  ];

  phases = [
    "installPhase"
  ];

  installPhase = ''
    mkdir $out
    cp ${disruptor.bazelHelpers.createCppBuildFile "xorg.libX11"} $out/BUILD.bazel
    cp -R ${pkgs.xorg.libX11}/* $out/
    cp -R ${pkgs.xorg.libX11.dev}/include $out/
  '';
}
