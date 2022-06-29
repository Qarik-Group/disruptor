# ADR 5: Project Management using GitHub Projects

## Context
Project management tool is useful to provide a vision of project, keeping track of a work and allows to align project with the goals set for it.

### Key benefits of applying project management tool:
1. Keeps work and goals organized in one place
* Having a one place to track the ongoing and future work and creating goals out of ideas
2. Eliminates confusion and increases efficiency
* Tool is the answer to questions that new, returnig or active collaborators may ask:
  * what are the current goals of this project?
  * where the goals are?
  * who is taking care of them?
  * what needs to be done to achieve the goal?
  * how can I help with achieving goal?
3. Improves collaboration effectiveness
* Referring to structured ideas as goals is easier then passing knowledge each time to anyone interested in collaboration
4. Aligns communication
* Unified way of referring different concepts in project itself
5. Enables development of ideas
* Creates a centralized place to store and develop ideas, going through the phases of being just a concept to prototype and finally getting implemented and released


### Open source examples:
Open source projects usually try to follow project management process to stay on the track and create the work environment for multiple collaborators.
- [tracking work in Kubernetes](https://github.com/kubernetes/kubernetes/projects)
- [bzlmod project in Bazel](https://github.com/bazelbuild/bazel/projects/9)
- [nixpkgs support](https://github.com/NixOS/nixpkgs/projects)


## Decision
We will use [GitHub Project Boards](https://docs.github.com/en/issues/organizing-your-work-with-project-boards/managing-project-boards/about-project-boards) to enable simple project management tool for resolving issues and to plan, track and deliver changes.\
GitHub Project Board are available on the GitHub platform for free, making it a tool that is easy to manage, accessible to everyone and integrating easly with collaboratos git flow.\

[UPDATE: 06/29/22] Project Boards didn't bring any value from initial proposal to the time of this ADR update. It seems they are not needed as they are not used and maintained.

## Status

Rejected.

## Consequences
To be seen.