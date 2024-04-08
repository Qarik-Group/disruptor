load("@rules_nixpkgs_cc//:cc.bzl", "nixpkgs_cc_configure")

def cpp_toolchains():

    nixpkgs_cc_configure(
        name = "gcc_10",
        attribute_path = "gcc10",
        repository = "@nixpkgs",
        exec_constraints = [],
        target_constraints = [
            "@//platforms/cpp:gcc_10",
        ],
        register = False,
    )

    nixpkgs_cc_configure(
        name = "gcc_11",
        attribute_path = "gcc11",
        repository = "@nixpkgs",
        exec_constraints = [],
        target_constraints = [
            "@//platforms/cpp:gcc_11",
        ],
        register = False,
    )

    nixpkgs_cc_configure(
        name = "gcc_13",
        attribute_path = "gcc13",
        repository = "@nixpkgs",
        exec_constraints = [],
        target_constraints = [
            "@//platforms/cpp:gcc_13",
        ],
        register = False,
    )

    # default toolchain
    nixpkgs_cc_configure(
        name = "gcc_12",
        attribute_path = "gcc12",
        repository = "@nixpkgs",
        register = False,
    )

def _non_module_deps_impl(ctx):
    cpp_toolchains()

non_module_deps = module_extension(
    implementation = _non_module_deps_impl,
)
