load("@//third_party/libuv:defs.bzl", "libuv")
load("@//third_party/ncurses:defs.bzl", "ncurses")
load("@//third_party/readline:defs.bzl", "readline")
load("@//third_party/xorg.libX11:defs.bzl", "libX11")
load("@//third_party/xorg.xorgproto:defs.bzl", "xorgproto")
load("@//third_party/xz:defs.bzl", "xz")

def third_party_deps():
    """Load 3rd party dependencies"""
    libuv()
    libX11()
    ncurses()
    readline()
    xorgproto()
    xz()
