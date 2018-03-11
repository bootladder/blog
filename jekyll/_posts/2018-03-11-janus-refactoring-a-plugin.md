---
layout: post
title: 'Janus: Refactoring a Plugin'
---
The sample Janus Plugins are written in C and they are very good.  
But, it's not very readable.  I'd like a higher level description of what the sample plugin app does.  Though the documentation is good, I still want a complete, high level description.  I'll do this by refactoring, which will also allow me to take out reusable snippets.
  
Particularly looking to refactor to improve:  separation of concerns  (single responsibility) .  Make it more obvious where the configuration file comes from.
  
# Pre- Notes
1.  Because these plugins are .so shared modules, I should be able to build the plugin by itself, then test with a real Janus instance.  Janus' build script builds the sample plugins with it, but that's just for convenience.  As a product developer, what I would do is have a separate build environment, git repo, etc. for my new plugin, build it, then deploy it to the /path/to/janus/lib/janus/plugins/  (I believe that's where you deploy them?)  
2.  Oh crap, it's built with autotools, I forgot.  I have no idea, and no desire to learn autotools.  Hmm how do I build the plugin?
3.  Ah yes, thank you https://github.com/mquander/janus-helloworld-plugin .  I will fork it!  Then copy over the recordplaytest demo!
4.  Ah, it didn't include any Janus headers, so those must come from the Janus installation on the server.  I don't have Janus installed on my laptop. Let's just make sure by attempting a build on my laptop.   Need jansson.  Ah yes, of course, plugins/plugin.h not found.  Let's make sure that exists on the server installation.  Well it's actually in /path/to/janus/include/janus/plugins .  Ah, checking the gcc -I flags, yes, it's in there.  Good!  Eh, let's build it on the cloud and then hook up a Jenkins later.
5.  Cool, it builds on my server that has Janus.  Let's... see if make install followed by restarting Janus will pick up the new plugin!
```
JANUS AudioBridge plugin initialized!
Loading plugin 'libjanus_helloworld.so'...
JANUS hello world plugin initialized!
Loading plugin 'libjanus_recordplay.so'...
JANUS Record&Play plugin initialized!
```
# Yay
6.  Quick side note, to clean up the build I did a `git clean -f -d -x`
7.  Now I can figure out how to change the name of the plugin and copy in the source from recordplaytest.  Well, doing a `grep -ir hello *` , excluding janus_helloworld.c , only shows a few matches.  That's cool, the name is not significant.  OK, it worked, but there are still "hello world" occurences in the source itself.
8.  Before I copy paste the source from the recordplay plugin, let's look at that `grep -i hello *` again.  Lots of matches, but which of those actually matter?  The #defines at the top, eg. `#define JANUS_HELLOWORLD_PACKAGE "janus.plugin.helloworld"` don't need to change, because they are simply returned by the getters.  In other words, I can copy paste the source from recordplay_plugin, the names won't be HELLO anymore, they'll be RECORDPLAY, and this is OK.
The interface implementation, `janus_plugin` is a struct of function pointers, so the names don't matter, they're just function pointers.  The symbol name of that implementation is `janus_helloworld_plugin` , ie. `static janus_plugin janus_helloworld_plugin` .  A pointer to this struct is returned by the `*create()` function.  
So, my conclusion is, I will only have to change the name of `janus.plugin.recordplay` or whatever it is, to something else, so the plugin namespace does not collide.  
9.  Now I can copy paste the source.  Ah crap.  There are headers in janus-gateway repo that have to be included in the build.  I don't know how to do that in autotools.  Dang!   Oh, looking at Makefile.am , it appears I can specify a -I flag.  Oh, I don't need to go to the source, the headers are exported in the Janus install.  Oh, the headers directory is already there!  Problem was the `../blah.h` should be `blah.h` .  Changing that...  OK, I built it again with `make`, no need to do any more autotools stuff.  I get an error, plugin could not be initialized because no configuration file could be read.  Let's copy one in there... `/path/to/janus/etc/janus/`  Yay, now it works!
