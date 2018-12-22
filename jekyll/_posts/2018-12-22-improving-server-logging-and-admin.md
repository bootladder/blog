---
layout: post
title: Improving server logging and admin
---
Sometimes my blog update pipeline fails.  Could be for many reasons:  
* Travis missed a webhook
* freejekyllbuilder.com down or failed
* SSL cert on deployer expired
* deployer can't deploy
  
Finding the problem basically means tracing
the flow in order of execution until the
break is found.  
  
I'd much rather just be told where/what the break was and just go to immediately fixing it.  
  
3 things must be done:  
# Identify the error 
eg. check error code, check system state with more code, match an error message  
# Handle/log the error
Stop pipeline, retry, try to fix the break, log  
Obvious trick: `set -e` in a bash script.
# Remove extraneous logs
Obvious trick: `mycommand > /dev/null`

