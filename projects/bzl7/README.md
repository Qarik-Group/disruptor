# bzl7

This project can execute various C++ and python targets with different gcc toolchains using bazel 7.

Check the `.bazelrc` file to see what configurations are supported.

## Go

We use Gazelle to generate the `BUILD.bazel` files for this project. Simply do:
```
# generates the BUILD files
bazel run gazelle
# executes the binary
bazel run //go/gazelle
```
