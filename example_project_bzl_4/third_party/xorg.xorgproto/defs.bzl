load("@io_tweag_rules_nixpkgs//nixpkgs:nixpkgs.bzl", "nixpkgs_package")
load("//third_party/nix:defs.bzl", "NIX_REPOSITORIES")

def xorgproto():
    nixpkgs_package(
        name = "xorg.xorgproto.headers",
        attribute_path = "xorg.xorgproto",
        build_file = "//third_party/xorg.xorgproto:BUILD.bazel.tmpl",
        repositories = NIX_REPOSITORIES,
    )
