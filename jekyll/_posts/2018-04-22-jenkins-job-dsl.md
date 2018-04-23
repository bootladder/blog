---
layout: post
title: 'Jenkins: Job DSL'
---
I don't know if it's my low-end VPS, java, or what, but Jenkins is **slow**.  
To create a new job, edit a job, really just about everything is slow.  
Right now I want to speed up:  creating a job, editing a job, viewing a job's definition.  
Obviously Job DSL is the answer.
  
[https://github.com/jenkinsci/job-dsl-plugin/wiki/Tutorial---Using-the-Jenkins-Job-DSL]
  
# Install JobDSL from Plugin Manager (this is obvious)
  
# Intro to Job DSL
First you manually create a job called the seed job.  In the build step,
instead of executing a script in the shell, select to run the Job DSL script.  
The Job DSL script is defining the new jobs that will be created as a result of
running this seed job.  
  
Run the seed job.  It generates jobs.  It does not run them, or check if they are defined sensibly.
Here is the console output.
```
Started by user engineering
Building in workspace /var/jenkins_home/workspace/job-dsl-1
Processing provided DSL script
Added items:
    GeneratedJob{name='DSL-Tutorial-1-Test'}
Finished: SUCCESS
```
Now go to the homepage of the seed job.  Notice it shows "Generated Items:" with the generated job.  
Now go to the homepage of Jenkins.  It shows the generated job, the seed job, and the existing manually created jobs.
  
# Huh... This does not help me!
Let's think this through.  What do I need?
* A Single Point of Truth (SPOT) for viewing and editing a job
* Atleast a file on the jenkins machine for the above.  Optional/better: git repo
* The SPOT must contain:
** Bitbucket, Github, Slack webhooks 
