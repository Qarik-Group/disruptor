{ disruptor, pkgs, lib, ... }:

let 
  ncursesStatic = pkgs.ncurses.overrideAttrs (oldAttrs: rec {
    enableStatic = true;

    configureFlags = [
      (lib.withFeature (!enableStatic) "shared")
      "--without-debug"
      "--enable-pc-files"
      "--enable-symlinks"
      "--with-manpage-format=normal"
      "--disable-stripping"
    ] ++ lib.optionals pkgs.stdenv.hostPlatform.isWindows [
      "--enable-sp-funcs"
      "--enable-term-driver"
    ];

    preFixup = "";
    postFixup = "";
});
in
pkgs.stdenv.mkDerivation {
  name = "ncurses-static.bzl";
  buildInputs = [
    ncursesStatic
    ncursesStatic.dev
  ];

  phases = [
    "installPhase"
  ];

  installPhase = ''
    mkdir $out
    cp ${disruptor.bazelHelpers.createCppBuildFile "ncurses"} $out/BUILD.bazel
    cp -R ${ncursesStatic}/* $out/
    cp -R ${ncursesStatic.dev}/include $out/
  '';
}
