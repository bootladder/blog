---
layout: post
title: Jenkins uses too much RAM
---
Dang, I finally figured out why my Docker containers were failing shortly after starting.  
That Error Code 137, Out of Memory.  
Really it's my stupid Redmine container that's taking up 30% of my 1GB RAM.  But I can't do anything about that.  
Jenkins I can consolidate the 3 instances into 1.  
Previously I had 1 Jenkins per toolchain, ie. 1 for arm-linux , 1 for arm-none, 1 for golang, etc.  I liked this because it keeps the toolchain installs independent.  
Now I have to use 1 Jenkins container with all the toolchains inside of it.
