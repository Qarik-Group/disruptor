let pkgs = import <nixpkgs> {};
    lib = pkgs.lib;
    stdenv = pkgs.stdenv;
    ncursesStatic = pkgs.ncurses.overrideAttrs (oldAttrs: rec {
      enableStatic = true;

      configureFlags = [
        (lib.withFeature (!enableStatic) "shared")
        "--without-debug"
        "--enable-pc-files"
        "--enable-symlinks"
        "--with-manpage-format=normal"
        "--disable-stripping"
      ] ++ lib.optionals stdenv.hostPlatform.isWindows [
        "--enable-sp-funcs"
        "--enable-term-driver"
      ];

      preFixup = "";
      postFixup = "";
    });
in pkgs.symlinkJoin {
  name = "ncurses";
  paths = [ ncursesStatic.out ncursesStatic.dev ];
}
