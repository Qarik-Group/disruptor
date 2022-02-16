{ disruptor, pkgs, lib, ... }:

{
  # TODO: It would make sense to add this as default step to every mkDerivation,
  # alongs side python equivalents etc.
  # This way, pkgs.* could be exposed nearly directly to Nix
  # Also: https://github.com/tweag/rules_nixpkgs/compare/master...wolfd:master
  createCppBuildFile = target_name: (pkgs.writeText 
    "BUILD.bazel"
    ''
    load("@rules_cc//cc:defs.bzl", "cc_library")

    package(default_visibility = ["//visibility:public"])

    cc_library(
        name = "${target_name}",
        srcs = glob([
            "lib/*.a*",
            "lib/*.so*",
        ]),
        hdrs = glob([
            "include/**/*.h",
            "include/**/*.hpp",
        ]),
        includes = [
            "include",
        ],
    )
    ''
  );
}
