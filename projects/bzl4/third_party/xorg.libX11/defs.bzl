load("@io_tweag_rules_nixpkgs//nixpkgs:nixpkgs.bzl", "nixpkgs_package")
load("//third_party/nix:defs.bzl", "NIX_REPOSITORIES")

def libX11():
    nixpkgs_package(
        name = "xorg.libX11.headers",
        attribute_path = "xorg.libX11.dev",
        build_file = "//third_party/xorg.libX11:BUILD.bazel.tmpl",
        repositories = NIX_REPOSITORIES,
    )

    nixpkgs_package(
        name = "xorg.libX11.lib",
        attribute_path = "xorg.libX11",
        build_file = "//third_party/xorg.libX11:BUILD.bazel.tmpl",
        repositories = NIX_REPOSITORIES,
    )
