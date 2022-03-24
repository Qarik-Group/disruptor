load("@io_tweag_rules_nixpkgs//nixpkgs:nixpkgs.bzl", "nixpkgs_package")
load("//third_party/nix:defs.bzl", "NIX_REPOSITORIES")

def xz():
    nixpkgs_package(
        name = "xz.x86_64_linux",
        nix_file_content = """
        let pkgs = import <nixpkgs> {}; in
        pkgs.symlinkJoin { name = "xz_x86_64_linux"; paths = with pkgs; [ xz xz.dev ]; }
        """,
        build_file = "//third_party/xz:BUILD.bazel.tmpl",
        repositories = NIX_REPOSITORIES,
    )

    nixpkgs_package(
        name = "xz.x86_64_darwin",
        nix_file_content = """
        let pkgs = import <nixpkgs> {}; in
        pkgs.symlinkJoin { name = "xz_x86_64_darwin"; paths = with pkgs; [ xz xz.dev ]; }
        """,
        build_file = "//third_party/xz:BUILD.bazel.tmpl",
        repositories = NIX_REPOSITORIES,
    )

    nixpkgs_package(
        name = "xz.aarch64_linux",
        nix_file_content = """
        let pkgs = import <nixpkgs> {}; in
        pkgs.pkgsCross.aarch64-multiplatform.symlinkJoin { name = "xz_aarch64_linux"; paths = with pkgs.pkgsCross.aarch64-multiplatform;  [ xz xz.dev ]; }
        """,
        build_file = "//third_party/xz:BUILD.bazel.tmpl",
        repositories = NIX_REPOSITORIES,
    )

    nixpkgs_package(
        name = "xz.ppc64_linux",
        nix_file_content = """
        let pkgs = import <nixpkgs> {}; in
        pkgs.pkgsCross.ppc64.symlinkJoin { name = "xz_ppc64_linux"; paths = with pkgs.pkgsCross.ppc64; [ xz xz.dev ]; }
        """,
        build_file = "//third_party/xz:BUILD.bazel.tmpl",
        repositories = NIX_REPOSITORIES,
    )

