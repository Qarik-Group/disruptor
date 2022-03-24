load("@io_tweag_rules_nixpkgs//nixpkgs:nixpkgs.bzl", "nixpkgs_git_repository")

NIX_REPOSITORIES = {
    "nixpkgs": "@nixpkgs",
}

def nix_repositories():
    """ Define nix repositories being used. """
    nixpkgs_git_repository(
        name = "nixpkgs",
        revision = "21.11",
        sha256 = "c77bb41cf5dd82f4718fa789d49363f512bb6fa6bc25f8d60902fe2d698ed7cc",
    )
