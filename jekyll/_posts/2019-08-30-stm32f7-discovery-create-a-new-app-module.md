---
layout: post
title: 'STM32F7 Discovery:  Create a new app module'
---
Now that I got the build working under CMake, the next thing to do is create my own app module.  
My plan is to combine pieces from the other modules to create a new module,
then start stripping everything else out of the build so it builds faster, is easier to modify,
runs faster, etc.
  
The module I'm starting with is `audio_recorder_win.c` because it's the smallest
module that includes some functionality that I want.
  
At the top level I do like how it looks:  
```
in main:
k_ModuleAdd(&steve_board);

in steve_win.c:
K_ModuleItem_Typedef  steve_board =
{
  3,
  "Audio Recorder   ",
  open_recorder,
  0,
  Startup,
  NULL,
}
;
```
  
I started by copy pasting files and changing the name.  I get about 20 multiple definitions
as expected.  Hopefully can start learning something about how the GUI framework works.  
  
# 1.  _cbNotifyStateChange() .  The only non-static _cb function.  Why?  

`steve_win.c` has this callback, and `audio_recorder_app.c` calls it in 2 places,
```
AUDIO_RECORDER_StopRec(void)
AUDIO_RECORDER_StopPlayer(void)
```
Haha, what is inside the definition of _cbNotifyStateChange() ?  You guessed it,
a reference to `audio_recorder_app.c`.  2 .c files including each others headers... smelly.  
  
Not too bad.  All the other references inside that callback are to the GUI framework.
But it is a namespace collision waiting to happen.
  
I mean really, what's the point of having a kernel at all when you do this stuff?  
  
# Common/audio_if.h  super bad namespace collision
I understand why they factored out audio_if.  It's because the video player and audio player have the same control interface.  
But the symbols defined under the common audio_if have the same prefix as the actual module, AUDIO_RECORDER.  
Because of that, you can't do a blind search/replace of the AUDIO_RECORDER prefix.  
  
# In general, I'd prefix all non-static symbols with the module name
```
void BSP_AUDIO_IN_TransferComplete_CallBack(void)
{
  osMessagePut ( AudioEvent, REC_BUFFER_OFFSET_FULL, 0);  
}

```
I may be judging too early here since this is a callback.  But, the file is 700 lines long.
It's not intiuitive that callbacks would be here with a global namespace.  
My intuition would be to have a layer of indirection to put the callbacks, where it is clear
where the callbacks are called from and where they are handled.  At the expense of possible overhead.  

