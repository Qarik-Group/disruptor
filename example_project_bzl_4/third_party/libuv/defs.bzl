load("@io_tweag_rules_nixpkgs//nixpkgs:nixpkgs.bzl", "nixpkgs_package")
load("//third_party/nix:defs.bzl", "NIX_REPOSITORIES")

def libuv():
    nixpkgs_package(
        name = "libuv.x86_64_linux",
        attribute_path = "libuv",
        build_file = "//third_party/libuv:BUILD.bazel.tmpl",
        repositories = NIX_REPOSITORIES,
    )

    nixpkgs_package(
        name = "libuv.aarch64_linux",
        attribute_path = "pkgsCross.aarch64-multiplatform.libuv",
        build_file = "//third_party/libuv:BUILD.bazel.tmpl",
        repositories = NIX_REPOSITORIES,
    )

    nixpkgs_package(
        name = "libuv.ppc64_linux",
        attribute_path = "pkgsCross.ppc64.libuv",
        build_file = "//third_party/libuv:BUILD.bazel.tmpl",
        repositories = NIX_REPOSITORIES,
    )

    nixpkgs_package(
        name = "libuv.riscv32_none",
        attribute_path = "pkgsCross.riscv32_embedded.libuv",
        build_file = "//third_party/libuv:BUILD.bazel.tmpl",
        repositories = NIX_REPOSITORIES,
    )
