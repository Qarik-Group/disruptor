load("@io_tweag_rules_nixpkgs//nixpkgs:nixpkgs.bzl", "nixpkgs_package")
load("//third_party/nix:defs.bzl", "NIX_REPOSITORIES")

def readline():
    nixpkgs_package(
        name = "readline.x86_64_linux",
	    nix_file = "//third_party/readline:readline-x86_64-linux.nix",
        nix_file_deps = [
            "//third_party/readline:common.nix",
            "//third_party/readline:no-arch_only.patch",
        ],
        build_file = "//third_party/readline:BUILD.bazel.tmpl",
	    repositories = NIX_REPOSITORIES,
    )

    nixpkgs_package(
        name = "readline.aarch64_linux",
	    nix_file = "//third_party/readline:readline-aarch64-linux.nix",
        nix_file_deps = [
            "//third_party/readline:common.nix",
            "//third_party/readline:no-arch_only.patch",
        ],
        build_file = "//third_party/readline:BUILD.bazel.tmpl",
    	repositories = NIX_REPOSITORIES,
    )

    nixpkgs_package(
        name = "readline.ppc64_linux",
        nix_file = "//third_party/readline:readline-ppc64-linux.nix",
        nix_file_deps = [
            "//third_party/readline:common.nix",
            "//third_party/readline:no-arch_only.patch",
        ],
        build_file = "//third_party/readline:BUILD.bazel.tmpl",
	    repositories = NIX_REPOSITORIES,
    )
