let pkgs = import <nixpkgs> {};
    lib = pkgs.lib;
    fetchurl = pkgs.fetchurl;
    pkg-config = pkgs.pkg-config;
    stdenv = pkgs.stdenv;
    buildPackages = pkgs.buildPackages;

in stdenv.mkDerivation rec {
  # Note the revision needs to be adjusted.
  abiVersion = "6";
  version = "6.3";
  name = "ncurses-${version}";

  # We cannot use fetchFromGitHub (which calls fetchzip)
  # because we need to be able to use fetchurlBoot.
  src = let
    # Note the version needs to be adjusted.
    rev = "v${version}";
  in fetchurl {
    url = "https://github.com/mirror/ncurses/archive/${rev}.tar.gz";
    sha256 = "1mawdjhzl2na2j0dylwc37f5w95rhgyvlwnfhww5rz2r7fgkvayv";
  };

  outputs = [ "out" ];
  setOutputFlags = false; # some aren't supported

  configureFlags = [
    "--enable-static"
    "--disable-shared"
    "--without-debug"
    "--enable-pc-files"
    "--enable-symlinks"
    "--with-manpage-format=normal"
    "--disable-stripping"
    "--without-cxx"
    ];

  depsBuildBuild = [
    pkgs.stdenv.cc
  ];

  nativeBuildInputs = [
    pkg-config
  ] ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    buildPackages.ncurses
  ];

  preConfigure = ''
    export PKG_CONFIG_LIBDIR="$dev/lib/pkgconfig"
    mkdir -p "$PKG_CONFIG_LIBDIR"
    configureFlagsArray+=(
      "--libdir=$out/lib"
      "--includedir=$out/include"
      "--bindir=$out/bin"
      "--mandir=$out/share/man"
      "--with-pkg-config-libdir=$PKG_CONFIG_LIBDIR"
    )
  '';

  enableParallelBuilding = true;

  doCheck = false;

  meta = with lib; {
    homepage = "https://www.gnu.org/software/ncurses/";
    description = "Free software emulation of curses in SVR4 and more";
    longDescription = ''
      The Ncurses (new curses) library is a free software emulation of curses in
      System V Release 4.0, and more. It uses Terminfo format, supports pads and
      color and multiple highlights and forms characters and function-key
      mapping, and has all the other SYSV-curses enhancements over BSD Curses.

      The ncurses code was developed under GNU/Linux. It has been in use for
      some time with OpenBSD as the system curses library, and on FreeBSD and
      NetBSD as an external package. It should port easily to any
      ANSI/POSIX-conforming UNIX. It has even been ported to OS/2 Warp!
    '';
    license = licenses.mit;
    platforms = platforms.all;
  };

  passthru = {
    inherit abiVersion;
  };
}
