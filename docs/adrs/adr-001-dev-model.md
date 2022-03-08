# ADR 1: Head-to-head development model

## Context

There are many approaches to structuring work of project versioning, development, testing and deployment. As everyone could have different experience and implicit expectations for said workflow, a common vision for how to approach that process is needed (otherwise, we would risk the repository becoming an unruly stitching of contradictory ideas). 

The term “vision” is chosen here deliberately - overspecification of things yet to come (tools used for “deployment”, testing details etc.) should not take place, instead a set of guiding principles must be defined for the specific, future implementations to follow. 
Those principles should include things like strategies for code branching, building, testing and versioning - namely, clearly describing (in broad strokes) the journey of a changeset from its inception to its release. 


## Decision

We will follow the “Head-to-head development model” (described in detail [here](https://www.twosigma.com/articles/introduction-to-head-to-head-development-part-1/)) - monorepo, trunk-based approach with focus on source integration (you can build everything from ground up with a single event) and pre-commit testing. The intent is to achieve dog-fooding of a certain sort: follow the same process that will most likely be an optimal strategy for project users. 

## Status

Accepted.

## Consequences
To be seen.
