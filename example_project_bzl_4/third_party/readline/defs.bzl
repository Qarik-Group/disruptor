load("@io_tweag_rules_nixpkgs//nixpkgs:nixpkgs.bzl", "nixpkgs_package")
load("//third_party/nix:defs.bzl", "NIX_REPOSITORIES")

def readline():
    nixpkgs_package(
        name = "readline.headers",
        attribute_path = "readline81.dev",
        build_file = "//third_party/readline:BUILD.bazel.tmpl",
        repositories = NIX_REPOSITORIES,
    )

    nixpkgs_package(
        name = "readline.lib",
        attribute_path = "readline81.out",
        build_file = "//third_party/readline:BUILD.bazel.tmpl",
        repositories = NIX_REPOSITORIES,
    )
