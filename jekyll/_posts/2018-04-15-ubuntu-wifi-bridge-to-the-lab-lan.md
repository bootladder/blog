---
layout: post
title: Ubuntu WiFi Bridge to the Lab LAN
---
I don't have Ethernet access to my gateway router; only wifi.  In my lab area I have a few Beaglebones on a switch.  I need to be able to access them from my laptops.  Ubuntu has a convenient wifi to ethernet bridge.
**Recap: to enable the bridge** 
network manager applet "edit connections", add, IPv4 settings method: shared to other computers".  
  
**I wish I knew how to set this up manually**
* Only 1 choice of subnet for the Ethernet side:  10.42.0.0
  
  
OK that's the recap.  The interesting part in this post is, I just replaced the bridge laptop with a different one.  Setting up the bridge like above is simple, but now my problem is, my dev laptop can't access the newly set up laptop.  
Previously what I did was, configure `~/.ssh/config` to name the bridge laptop, and also named all the hosts behind the bridge (the Beaglebones).  To make this work I used the ProxyCommand feature of ssh config.  
  
So 1 obvious option is to rewrite all the entries in ssh config.  
But another cool option would be to set up some routing.  I suppose, the bridge laptop could push routes to everybody, saying that the 10.42.0.0 network is accessible through the 10.0.1.X, the IP address of the bridge on the WiFi subnet.
