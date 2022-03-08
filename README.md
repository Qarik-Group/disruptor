Disruptor
---
[![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)
[![ci-checks](https://github.com/Qarik-Group/disruptor/actions/workflows/ci.yaml/badge.svg?branch=master)](https://github.com/Qarik-Group/disruptor/actions/workflows/ci.yaml)

### Example
```bash
$ ./nix-shell.sh
...
$ cd example_project_bzl_4
$ bazel build //...
```

### Supported machines

At the moment, the project is built with {x86/x64, aarch64} architecture in mind, targeting GNU Linux-based distributions. Machine should either have user namespaces for unprivileged users enabled or have nix pre-installed in single-user mode.

To be implemented:
* MacOS support
* Fallback to `proot` for machines without support for user namespaces for unprivileged users

### Development shell
Simply type `./nix-shell.sh` to be dropped into a shell with all batteries included. 

Project utilizes [nix](https://builtwithnix.org) to deliver a uniform, homogeneous development environment for each of its users & contributors - you are going to be using the same dependencies (bash, core utils, system libraries, bazel etc.), installed from the same source and configured in the same way. No more “works on my machine”-syndrome, as everyone has reproducible and identical working environments. 

_Note_: Dependencies are automatically loaded / unloaded, as the user traverses the project tree - i.e. entering `example_project_bzl4` will result in loading up all of the project dependencies, while moving out of the example project tree will unload bazel. 
This is done to stay relatively lean in terms of what the average user needs to load.

#### Technical details
* One can install nix globally for the user, which will then prevent the nix-shell.sh script from running everything from chrooted environment
* Nix with daemon enabled is not supported (so called multi-user installation) - this is due to nix configuration that happens on the fly, which would need to be propagated to daemon 


### Tracking decisions

It has been decided to track important choices in this project, with the help of  Architectural Decision Records (ADRs for short, concept explained [here](https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions) or [here](https://adr.github.io)). The main intent is to ensure everyone developing the project is well aligned with it's goals, always can quickly get up to speed or propose a new direction.

The ADRs are to be placed in `docs/adrs` directory of this repository and follow conventions described in the [initial adr](docs/adrs/adr-000-using-adrs.md).
