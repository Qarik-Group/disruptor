load("@io_tweag_rules_nixpkgs//nixpkgs:repositories.bzl", "rules_nixpkgs_dependencies")

def deps_init():
    rules_nixpkgs_dependencies()
