load("@io_tweag_rules_nixpkgs//nixpkgs:nixpkgs.bzl", "nixpkgs_package")
load("//third_party/nix:defs.bzl", "NIX_REPOSITORIES")

def ncurses():
    nixpkgs_package(
        name = "ncurses",
        nix_file = "//third_party/ncurses:ncurses.nix",
        build_file = "//third_party/ncurses:BUILD.bazel.tmpl",
        repositories = NIX_REPOSITORIES,
    )
