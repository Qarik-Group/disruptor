# ADR 3: Continous Integration using GitHub Actions

## Context
Continuous integration (CI) is the practice of automating the integration of code changes from multiple contributors into a single software project. It’s a primary DevOps best practice, allowing developers to frequently merge code changes into a central repository where builds and tests then run. Automated tools are used to assert the new code’s correctness before integration. Each integration can then be verified by an automated build and automated tests. While automated testing is not strictly part of CI it is typically implied.

One of the key benefits of integrating regularly is that you can detect errors quickly and locate them more easily. As each change introduced is typically small, pinpointing the specific change that introduced a defect can be done quickly.

“Continuous Integration doesn’t get rid of bugs, but it does make them dramatically easier to find and remove.” -Martin Fowler, Chief Scientist, ThoughtWorks

## Decision
We will use GitHub Actions to model and implement the Continous Integration process for the project.

## Status

Proposed.

## Consequences
Availability of CI is connected with the availability of GitHub Platform itself.

## Notes
Context is partially merged from:
https://www.atlassian.com/continuous-delivery/continuous-integration
https://www.cloudbees.com/continuous-delivery/continuous-integration