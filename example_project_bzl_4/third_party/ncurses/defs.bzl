load("@io_tweag_rules_nixpkgs//nixpkgs:nixpkgs.bzl", "nixpkgs_package")
load("//third_party/nix:defs.bzl", "NIX_REPOSITORIES")

def ncurses():
    nixpkgs_package(
        name = "ncurses.x86_64_linux",
        nix_file = "//third_party/ncurses:ncurses-x86_64-linux.nix",
        nix_file_deps = [ "//third_party/ncurses:common.nix" ],
        build_file = "//third_party/ncurses:BUILD.bazel.tmpl",
        repositories = NIX_REPOSITORIES,
    )

    nixpkgs_package(
        name = "ncurses.aarch64_linux",
        nix_file = "//third_party/ncurses:ncurses-aarch64-linux.nix",
        nix_file_deps = [ "//third_party/ncurses:common.nix" ],
        build_file = "//third_party/ncurses:BUILD.bazel.tmpl",
        repositories = NIX_REPOSITORIES,
    )

    nixpkgs_package(
        name = "ncurses.ppc64_linux",
        nix_file = "//third_party/ncurses:ncurses-ppc64-linux.nix",
        nix_file_deps = [ "//third_party/ncurses:common.nix" ],
        build_file = "//third_party/ncurses:BUILD.bazel.tmpl",
        repositories = NIX_REPOSITORIES,
    )

    nixpkgs_package(
        name = "ncurses.x86_64_darwin",
        nix_file = "//third_party/ncurses:ncurses-x86_64-darwin.nix",
        nix_file_deps = [ "//third_party/ncurses:common.nix" ],
        build_file = "//third_party/ncurses:BUILD.bazel.tmpl",
        repositories = NIX_REPOSITORIES,
    )
