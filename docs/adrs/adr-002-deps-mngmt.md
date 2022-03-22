# ADR 2: Dependecy management using Nix package manager

## Context

Ideally all developers working on a project should never fall into the pitfall of "it works on my machine" - the tools they are using, its configuration should be identical all across the systems, resulting in reproducible artifacts and behaviours, from the dev hosts up to "production environments". 
Achieving said goal is not a trivial task however - retaining reproducibility has traditionally been a utopia, with concessions frequently made due to the practicalities. The problem was exacerbated by system-wide dependencies, often to the point of a platform lock-in.
We would like to provision working environments to developers, users and production-environments that are reproducible in their nature, across all setup, where everyone is using exactly the same binaries, dependencies and configuration. 

## Decision
We will use [nix package manager](https://nixos.org/) as the means of obtaining reproducibility and hermeticity (hard to have one without other) of our project working environments, as well as delivering hard-pinned dependencies of components traditionally delivered from the OS-level. 

Besides guix, no other tool seems mature enough to bring aforementioned qualities in a declarative, effort-efficient manner. 

## Status

Accepted.

## Consequences
To be seen.
