load("@io_tweag_rules_nixpkgs//nixpkgs:nixpkgs.bzl", "nixpkgs_package")
load("//third_party/nix:defs.bzl", "NIX_REPOSITORIES")

def libuv():
    nixpkgs_package(
        name = "libuv",
        attribute_path = "libuv",
        build_file = "//third_party/libuv:BUILD.bazel.tmpl",
        repositories = NIX_REPOSITORIES,
    )
