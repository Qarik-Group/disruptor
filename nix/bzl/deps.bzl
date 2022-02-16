load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def distruptor_deps():
    maybe(
        http_archive,
        name = "io_tweag_rules_nixpkgs",
        sha256 = "7efb0f82cda5cdaa8e96b687734c5704b91353561d7889e5d84a13b6d30f4cb8",
        strip_prefix = "rules_nixpkgs-05a445575de51872f528c537cc7ff3ab11114f21",
        urls = ["https://github.com/tweag/rules_nixpkgs/archive/05a445575de51872f528c537cc7ff3ab11114f21.tar.gz"],
    )
