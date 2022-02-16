{ disruptor, pkgs, lib, ... }:

pkgs.stdenv.mkDerivation {
  name = "xorg.xorgproto.bzl";
  buildInputs = [
    pkgs.xorg.xorgproto
  ];

  phases = [
    "installPhase"
  ];

  installPhase = ''
    mkdir $out
    cp ${disruptor.bazelHelpers.createCppBuildFile "xorg.xorgproto"} $out/BUILD.bazel
    cp -R ${pkgs.xorg.xorgproto}/* $out/
  '';
}
