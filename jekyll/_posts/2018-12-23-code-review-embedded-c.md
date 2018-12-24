---
layout: post
title: 'Code Review: Embedded C'
---
I learned a lot at this last job I had.  So much,
I realized the code from my last job sucks.  
Now I want to revisit it but it's going to be a drag.  
# why?
  
Multiple reasons
* Smelly code, ie. comments, long functions
* Not enough refactoring
* Didn't take the time to write clean, SOLID code.
* It's just not good enough
  
A big thing was:  **no tests** .  
* Without unit tests you lose a layer of documentation
* That doc layer gives you the chance to state the intended behavior
  
Changing the code is risky in the following ways:  
**Ordering, sequence** of function calls ie. X is called before Y.  
**Standalone call must be made** maybe for a side effect.  
This particularly goes for hardware init code.  
  
Another thing:  **messy build system**   
I had experimented with make, CMake, different testing frameworks, g++, etc.  
I never decided on one and now there's scattered fragments of all the experiments.
  
I've found that C build systems are the most verbose and 
are a more important piece of the project than for build systems for other languages.  
Mostly because the C tools aren't as high level.  
  
So it's really important to get it right.  Not just barely usable.
  
Another thing:  **duplication ie. non-DRY**
  
I think DRY relates to project file structure.  
I have 5 product variants.  So I had 5 projects, 
ie. 5 git repos, ie.5 independent source trees, 5 build systems.
  
I have 5 copies of hardware init code.  But this made sense
because they're in general slightly different.  
  
I spent a lot of time thinking about this problem but didn't get
a clean solution.  Now I'm thinking it's better to have everything
under 1 project, 1 git repo, 1 source tree, 1 build system.
  
But 1 downside to the monolith is it's not as modular.  
  
  
# Rehab
