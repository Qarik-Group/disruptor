load("@io_tweag_rules_nixpkgs//nixpkgs:nixpkgs.bzl", "nixpkgs_cc_configure")
load("//third_party/nix:defs.bzl", "NIX_REPOSITORIES")


def cpp_toolchains():
    # Naming convention (after nixpkgs)
    # cpp-toolchain-<cpu>-<vendor>-<os>-<abi>
    # This string representation is used in nixpkgs for historic reasons.
    # Note that <vendor> is often unknown and <abi> is optional. 
    # There’s also no unique identifier for a platform, 
    # for example unknown and pc are interchangeable.

    nixpkgs_cc_configure(
        name = "cpp-toolchain-x86_64-linux-gcc11",
        repositories = NIX_REPOSITORIES,
        attribute_path = "gcc11",
        nix_file_content = "import <nixpkgs> {}",
        exec_constraints = [
            "@platforms//cpu:x86_64",
            "@platforms//os:linux",
        ],
        target_constraints = [
            "@platforms//cpu:x86_64",
            "@platforms//os:linux",
            "@//platforms:gcc11",
        ],
    )

    nixpkgs_cc_configure(
        name = "cpp-toolchain-x86_64-linux-gcc9",
        repositories = NIX_REPOSITORIES,
        attribute_path = "gcc9",
        nix_file_content = "import <nixpkgs> {}",
        exec_constraints = [
            "@platforms//cpu:x86_64",
            "@platforms//os:linux",
        ],
        target_constraints = [
            "@platforms//cpu:x86_64",
            "@platforms//os:linux",
            "@//platforms:gcc9",
        ],
    )

    nixpkgs_cc_configure(
        name = "cpp-toolchain-aarch64-linux",
        nix_file = "@bzl4//third_party/cpp_toolchains:aarch64-linux.nix",
        repositories = NIX_REPOSITORIES,
        exec_constraints = [
            "@platforms//cpu:x86_64",
            "@platforms//os:linux",
        ],
        target_constraints = [
            "@platforms//cpu:aarch64",
            "@platforms//os:linux",
        ],
    )

    nixpkgs_cc_configure(
        name = "cpp-toolchain-ppc64-linux",
        nix_file = "@bzl4//third_party/cpp_toolchains:ppc64-linux.nix",
        repositories = NIX_REPOSITORIES,
        exec_constraints = [
            "@platforms//cpu:x86_64",
            "@platforms//os:linux",
        ],
        target_constraints = [
            "@platforms//cpu:ppc",
            "@platforms//os:linux",
        ],
    )

    nixpkgs_cc_configure(
        name = "cpp-toolchain-x86_64-darwin",
        repositories = NIX_REPOSITORIES,
        exec_constraints = [
            "@platforms//cpu:x86_64",
            "@platforms//os:macos",
        ],
        target_constraints = [
            "@platforms//cpu:x86_64",
            "@platforms//os:macos",
        ],
    )
