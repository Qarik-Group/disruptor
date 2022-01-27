load("@io_tweag_rules_nixpkgs//nixpkgs:nixpkgs.bzl", "nixpkgs_package")
load("//third_party/nix:defs.bzl", "NIX_REPOSITORIES")

def readline():
    nixpkgs_package(
        name = "readline",
	nix_file = "//third_party/readline:readline.nix",
        nix_file_deps = [
            "//third_party/readline:no-arch_only.patch"
        ],
        build_file = "//third_party/readline:BUILD.bazel.tmpl",
	repositories = NIX_REPOSITORIES,
    )
