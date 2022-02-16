load("@distruptor_nix//bzl:defs.bzl", "get_nix_package")

def nix_packages_init():
    get_nix_package("libuv")
    get_nix_package("ncurses")
    get_nix_package("xorg.libX11")
    get_nix_package("readline")
    get_nix_package("xorg.xorgproto")
    get_nix_package("xz")
