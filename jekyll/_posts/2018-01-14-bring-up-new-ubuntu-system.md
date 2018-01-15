---
layout: post
title: Bring up New Ubuntu System
---
Ubuntu on my laptop was crashing regularly and taking way too long to boot from the SSD.  
  
# Editing this Blog
  Need: Clone git repo, apt-get install ruby ruby-dev, gem install bundler, bundle install  
Need: Production repo URL, so it can be pushed to.  
The prod remote is a bare git repo on the production server.  
Put in the url to it?  Behind web root?  *A:  use the whole SSH URL*  
Use ~/.ssh/config to specify the key to be used.  
*New*:  The built \_site had been stored in the git repo, so it
could be directly copied into the bare remote, and then copied to the deploy.
I thought of course, to `git rm` the \_site and then run `jekyll build`
inside /deploy, but of course jekyll was not installed.  
So for now I put the built \_site back in the repo.

# Atom IDE
`sudo add-apt-repository ppa:webupd8team/atom`  
`sudo apt update; sudo apt install atom`  
`Source: http://tipsonubuntu.com/2016/08/05/install-atom-text-editor-ubuntu-16-04/`

# Aliases
```
#Steve Aliases
alias l='ls -ltrh --color=auto'
alias gs='git status'
alias gl='git log'
alias gd='git diff'
```

# VIM
`sudo apt-get install vim`

# Golang
`sudo apt-get install golang-go`  
```
vi ~/.bashrc
export GOPATH=~/prog/go
export PATH=$PATH:~/prog/go/bin
```

# Thunderbird
Don't download all emails from IMAP server, only last 30 days
`Source: https://support.mozilla.org/en-US/questions/1066286`  
Why doesn't this work, it downloaded all my emails.  Maybe because there weren't that many of them?

# Servers
Need SSH Keys, Hostnames, Root Passwords, IP Addresses
