let pkgs = import <nixpkgs> {};
    lib = pkgs.lib;
    fetchurl = pkgs.fetchurl;
    pkg-config = pkgs.pkg-config;
    stdenv = pkgs.stdenv;
    buildPackages = pkgs.buildPackages;

in stdenv.mkDerivation rec {
  pname = "readline";
  version = "8.1";

  src = fetchurl {
    url = "mirror://gnu/readline/readline-${meta.branch}.tar.gz";
    sha256 = "00ibp0n9crbwx15k9vvckq5wsipw98b1px8pd8i34chy2gpb9kpq";
  };

  outputs = [ "out" ];

  configureFlags = [
    "--enable-static"
    "--disable-shared"
    ];

  patchFlags = [ "-p0" ];

  patches =
    [ ./no-arch_only.patch
    ];

  meta = with lib; {
    description = "Library for interactive line editing";

    longDescription = ''
      The GNU Readline library provides a set of functions for use by
      applications that allow users to edit command lines as they are
      typed in.  Both Emacs and vi editing modes are available.  The
      Readline library includes additional functions to maintain a
      list of previously-entered command lines, to recall and perhaps
      reedit those lines, and perform csh-like history expansion on
      previous commands.

      The history facilities are also placed into a separate library,
      the History library, as part of the build process.  The History
      library may be used without Readline in applications which
      desire its capabilities.
    '';

    homepage = "https://savannah.gnu.org/projects/readline/";

    license = licenses.gpl3Plus;

    maintainers = with maintainers; [ dtzWill ];

    platforms = platforms.unix;
    branch = "8.1";
  };
}
