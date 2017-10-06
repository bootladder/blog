---
layout: post
title: Reverse SSH access to beaglebone
---
I'm leaving for the weekend and I want access to my 2 beaglebones.  
1 is my system under test, the other controls a USB programmer
that can flash a microcontroller on the SUT.
  
Following this guide http://xmodulo.com/access-linux-server-behind-nat-reverse-ssh-tunnel.html
  
First I'll locally SSH into the beaglebone.  

```
homeserver~$ ssh -fN -R 10022:localhost:22 relayserver_user@1.1.1.1 
```
  
* -R for reverse tunnel.  Port 10022 on remote host is forwarded to port 22 on beaglebone
* 10022 is arbitrary
* port 22 is the SSH port that beaglebone sshd is listening on
* -f for background
* -N for "don't execute a command"
  
Note:  I forgot that my VPS had disabled password logins; only permitted by key.  
I had only installed 1 key on the VPS:  for my main laptop.  
So to install 2 more keys, I SSHed into the VPS with my main laptop.  
Temporarily allowed password logins.  
Then used ssh-copy-id to install the keys on VPS.  
Finally, disable password logins again.  
  
Last step is to add the command in rc.local.
