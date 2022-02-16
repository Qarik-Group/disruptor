load("@distruptor_nix//bzl:nix-file-deps.bzl", "NIX_FILE_DEPS")
load("@io_tweag_rules_nixpkgs//nixpkgs:nixpkgs.bzl", "nixpkgs_git_repository", "nixpkgs_package")

NIX_REPOSITORIES = {
    "nixpkgs": "@nixpkgs",
}

def nix_repositories_init():
    """ Define nix repositories being used. """
    nixpkgs_git_repository(
        name = "nixpkgs",
        revision = "21.11",
        sha256 = "c77bb41cf5dd82f4718fa789d49363f512bb6fa6bc25f8d60902fe2d698ed7cc",
    )

BAZEL_PLATFROM_TO_NIX_ARCH = {
    "x86_64_linux": None,
    "x86_64_darwin": None,
    "aarch64_linux": "aarch64-multiplatform",
    "ppc64_linux": "ppc64",
}

def nix_package(name, visibility = ["//visibility:public"]):
    native.alias(
        name = name,
        actual = select({
            "@bazel_tools//src/conditions:linux_x86_64": "@{0}.x86_64_linux//:{0}".format(name),
            "@bazel_tools//src/conditions:darwin_x86_64": "@{0}.x86_64_darwin//:{0}".format(name),
            "@bazel_tools//src/conditions:linux_aarch64": "@{0}.aarch64_linux//:{0}".format(name),
            "@bazel_tools//src/conditions:linux_ppc64le": "@{0}.ppc64_linux//:{0}".format(name),
        }),
        visibility = visibility,
    )

def get_nix_package(name, attribute_path = None):
    if not attribute_path:
        attribute_path = name

    for platform, nix_arch in BAZEL_PLATFROM_TO_NIX_ARCH.items():
        nixpkgs_package(
            name = "%s.%s" % (name, platform),
            attribute_path = attribute_path,
            nix_file = "@distruptor_nix//:default.nix",
            nixopts = [ "--argstr", "crossTarget", nix_arch ] if nix_arch else None,
            nix_file_deps = NIX_FILE_DEPS,
            repositories = NIX_REPOSITORIES,
        )
