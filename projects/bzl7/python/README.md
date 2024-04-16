# python

## hello world

It is possible to execute this script using various toolchains:
```
bazel run --config=python310 //python/hello_world:main
bazel run --config=python311 //python/hello_world:main
bazel run --config=python312 //python/hello_world:main
```

## pip example
To update the requirements file, simply run:
```
 bazel run //python/pip:python_requirements.update
```

Now you may execute:
```
bazel run //python/pip:main
```

Note only the default toolchain is supported currently.
