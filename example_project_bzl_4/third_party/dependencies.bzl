load("@//third_party/libuv:defs.bzl", "libuv")
load("@//third_party/xorg.libX11:defs.bzl", "libX11")
load("@//third_party/xorg.xorgproto:defs.bzl", "xorgproto")


def third_party_deps():
    """Load 3rd party dependencies"""
    libuv()
    libX11()
    xorgproto()
