load("@bazel_skylib//rules:common_settings.bzl", "string_flag")

string_flag(name = "compiler", build_setting_default = "gcc9")

config_setting(
    name = "gcc11",
    flag_values = {
        ":compiler": "gcc11",
    },
)

config_setting(
    name = "gcc9",
    flag_values = {
        ":compiler": "gcc9",
    },
)