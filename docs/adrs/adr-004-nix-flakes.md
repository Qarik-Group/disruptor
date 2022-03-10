# ADR 4: Adopting Nix Flakes

## Context

We're currently using Nix flakes, which has lead to some friction with adoption - users new to Nix see an added complexity. There has been a call to simplify with refactoring Flakes into Nix expressions.

### tl;dr Points

Points pro de-flaking:
- Easier adoption, less friction, the ability to "dip feet" vs "dive-in" with impure shells.

Points against de-flaking:
- De-flaking the publicly visible repo that we want to attract people with Nix knowledge is a big no-no. It can send a message that we don't understand the concepts behind
- Disruptor should be as polished as possible, no matter the shortcomings of our adopters. Forking the repo and simplifying it as a viable option, if the only difference are Flakes.
- Getting rid of flakes would not make disruptor more palatable to average Joe. "Distruptor" is aimed to be a poster-child, usable template, state-of-the-art approach to delivering reproducible, hermetic, pleasant software development experience. Bonus points go to working in environments which are somewhat hostile to end-user (your typical corporate restrictions around installing software).

### The flow

We have a "wrapper script" [1] (nix-shell.sh) which automates spawning homogeneous working environments across different machines (with and via nix), which also attempts to address "hostile env" issues. Then we have second layer of "on-the-fly" load-up of working environments dedicated for given project [2], which take nix setup for granted. At the end, we have Bazel project [3] which deals with best practices for Bazel and utilising nix package manager underneath (nixpkgs), once again assuming it was already set up.

Hence, we have a layered approach of
[1] Prepare homogeneous working environment with nix
[2] Load up dependencies needed for given project
[3] Presentation of practices for given project (i.e. Bazel).

Nix flakes are used only for [1], which - is least predestined to be tinkered with by project users. What I think is important to notice:
After PR #18 was merged, we may remove any references to flakes in “default|shell.sh” files in the projects subdirectories (i.e. the example_bzl_4_project/shell.nix), as default statement of “import <nixpkgs>” will still load the correct thing).
If we just get rid of the flakes, we lose certain capabilities flake give us - which mostly deals with easier control over inputs/outputs and their versioning. Without it, we are de-hermetizing the whole project, so we need to implement alternatives in pure nix (otherwise - the disruptor purpose is potentially lost). This is feasible and in fact may give us some benefits, as flakes do come with some issues in large repositories (which we will also need to address some time)

Ultimately removing flakes will not take the complexity away, only move it to custom written nix expressions. This is a candidate approach for other issues (re: flake issues), rather than misgivings above.

Technically, there is nothing stopping project users from skipping [1], installing nix globally and running [2] directly via nix-shell invocations (as we will be removing references to flake.lock).

Summarising my thoughts: If convincing the project user to deal with nix flakes / hermetic working environment is too much, we can have the project structure in such a way that allows running it in a "dirty/direct" manner (skipping [1]).

## Decision

## Status

In discussion.

## Consequences

## Notes