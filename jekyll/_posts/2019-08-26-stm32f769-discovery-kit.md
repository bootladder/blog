---
layout: post
title: STM32F769 Discovery Kit
---
  
I got a STM32F769 Discovery Kit to play with.  Let's bring it up, under control.  
   
The first experiment I need to do is making sure I can restore the flash to the factory state.
1. Read the flash and write it back
1. Compare the included demo project HEX file with the flash on board (should be the same)
1. Build the demo project from source and flash it
   
Once I do this I can safely make stupid mistakes :)
  
I'll do this the easy way first, and then switch to standalone OpenOCD later.  Go to <www.openstm32.org> and download the "System Workbench for STM32".  
This includes the Eclipse-based IDE, build toolchain and flash programming.  
  
While that downloads let's find the included HEX file for the demo firmware, and the IDE project file we'll use.  
```
steve@McBain:~/prog/embedded/STM32Cube_FW_F7_V1.15.0/Projects/STM32F769I-Discovery/Demonstrations/STemWin $$$ f *.hex
./Binary/STM32CubeDemo_STM32769I-DISCO_V1.4.0.hex
./Binary/STM32769I-DISCO_DEMO_V1.0.0_FULL.hex

steve@McBain:~/prog/embedded/STM32Cube_FW_F7_V1.15.0/Projects/STM32F769I-Discovery/Demonstrations/STemWin $$$ f *proj*
./SW4STM32/STM32F769I-Discovery_Demo/.cproject
./SW4STM32/STM32F769I-Discovery_Demo/.project
./MDK-ARM/Project.uvprojx
```
Isn't `find` nice?   
  
OK it downloaded so let's install it.
```
steve@McBain:~/Downloads $$$ sudo apt install gksu    # first install gksudo
...
steve@McBain:~/Downloads $$$ chmod +x install_sw4stm32_linux_64bits-v2.9.run 
steve@McBain:~/Downloads $$$ ./install_sw4stm32_linux_64bits-v2.9.run
```
IMO, change the stupid default installation path from the top of the home directory to
something sane, like `/home/steve/install` or `/opt/software`.  
  
Note the install does add udev rules to `/etc/udev/rules.d`.  
  
Let's get started!  Go to wherever you installed SW4STM32 and run `./eclipse`.  
And... great, I don't see a way to read the flash.  Atmel Studio had this in a separate "Flash Programming" widget.  
I got the hint that SW4STM32 does use OpenOCD so I should be able to find some usable `openocd.cfg`.  
  
Doing a `grep -ir stlink` returns a humourous number of results.  The file we want is not in the STM32Cube-FW_F7... directory.
It is in the SW4STM32 install directory.  And we find it:  
```
steve@McBain:~/installs/sw4stm32 $$$ grep -ir stlink | grep 769
plugins/fr.ac6.mcu.debug_2.5.0.201904120827/resources/openocd/scripts/st_board/stm32f769i_disc1.cfg:# This is for using the onboard STLINK/V2-1
plugins/fr.ac6.mcu.debug_2.5.0.201904120827/resources/openocd/scripts/st_board/stm32f769i_disc1.cfg:source [find interface/stlink-v2-1.cfg]
plugins/fr.ac6.mcu.debug_2.5.0.201904120827/resources/openocd/scripts/st_board/stm32f769i_eval.cfg:# This is for using the onboard STLINK/V2-1
plugins/fr.ac6.mcu.debug_2.5.0.201904120827/resources/openocd/scripts/st_board/stm32f769i_eval.cfg:source [find interface/stlink-v2-1.cfg]
plugins/fr.ac6.mcu.debug_2.5.0.201904120827/resources/openocd/scripts/st_board/stm32f769i_disco.cfg:# This is for using the onboard STLINK/V2-1
plugins/fr.ac6.mcu.debug_2.5.0.201904120827/resources/openocd/scripts/st_board/stm32f769i_disco.cfg:source [find interface/stlink-v2-1.cfg]
```
The files ending with `disc1` and `disco` are identical so I'll pick either one.  
   
Oh no, my `apt install openocd` install did not include config for the STM32F7 : (  Note below there is F4 config but not F7.
```
steve@McBain:~/installs/sw4stm32/plugins/fr.ac6.mcu.debug_2.5.0.201904120827/resources/openocd/scripts $$$ openocd -f st_board/stm32f769i_disco.cfg
Open On-Chip Debugger 0.9.0 (2018-01-24-01:05)
Licensed under GNU GPL v2
For bug reports, read
  http://openocd.org/doc/doxygen/bugs.html
Info : The selected transport took over low-level target control. The results might differ compared to plain JTAG/SWD
Error: flash driver 'stm32f7x' not found
steve@McBain:~/installs/sw4stm32/plugins/fr.ac6.mcu.debug_2.5.0.201904120827/resources/openocd/scripts $$$ find /usr/share/openocd/ -name stm32f7*
steve@McBain:~/installs/sw4stm32/plugins/fr.ac6.mcu.debug_2.5.0.201904120827/resources/openocd/scripts $$$ find /usr/share/openocd/ -name stm32f4*
/usr/share/openocd/scripts/board/stm32f4discovery.cfg
/usr/share/openocd/scripts/board/stm32f429discovery.cfg
/usr/share/openocd/scripts/target/stm32f4x_stlink.cfg
/usr/share/openocd/scripts/target/stm32f4x.cfg
```
  
Ah crap, more bad news from <https://www.carminenoviello.com/2015/07/13/started-stm32f746g-disco/>  :  
```
As I've said at the beginning of this tutorial, the current stable release of OpenOCD (0.9) can't be used to flash STM32F7 processors, since they have a different internal flash from other STM32 MCUs, which requires a different programming procedure. Fortunately, Rémi PRUD'HOMME (I think an ST engineer) has submitted a patch to OpenOCD to enable support STM32F7 family and STM32F746-DISCO board. This patch has been merged in the development OpenOCD repo. So, we can compile a custom version easily. However, I'll not give instructions on how to compile OpenOCD on the Windows platform (read this comment to download a precompiled patched version). Please, check OpenOCD instructions about this.
```
  
Ah yes, good.  The `apt install openocd` version I got was `Open On-Chip Debugger 0.9.0 (2018-01-24-01:05)` , and the one bundled with SW4STM32 was
```
steve@McBain:~/installs/sw4stm32/plugins/fr.ac6.mcu.externaltools.openocd.linux64_1.23.0.201904120827/tools/openocd/bin $$$ ./openocd -v
Open On-Chip Debugger 0.10.0+dev-00021-g524e8c8 (2019-04-12-08:33)
Licensed under GNU GPL v2
For bug reports, read
  http://openocd.org/doc/doxygen/bugs.html
```
  
And now for the annoyingly long command line:  
```
steve@McBain:~/installs/sw4stm32/plugins/fr.ac6.mcu.externaltools.openocd.linux64_1.23.0.201904120827/tools/openocd/bin $$$ sudo ./openocd -f stm32f769i_disco.cfg -s /home/steve/installs/sw4stm32/plugins/fr.ac6.mcu.debug_2.5.0.201904120827/resources/openocd/scripts/st_board -s /home/steve/installs/sw4stm32/plugins/fr.ac6.mcu.debug_2.5.0.201904120827/resources/openocd/scripts/
Open On-Chip Debugger 0.10.0+dev-00021-g524e8c8 (2019-04-12-08:33)
Licensed under GNU GPL v2
For bug reports, read
  http://openocd.org/doc/doxygen/bugs.html
Info : The selected transport took over low-level target control. The results might differ compared to plain JTAG/SWD
adapter speed: 2000 kHz
srst_only separate srst_nogate srst_open_drain connect_assert_srst
adapter_nsrst_delay: 100
Info : Listening on port 6666 for tcl connections
Info : Listening on port 4444 for telnet connections
Info : clock speed 2000 kHz
Info : STLINK v2.1 JTAG v29 API v2 M18 VID 0x0483 PID 0x374B
Info : using stlink api v2
Info : Target voltage: 3.228947
Info : Unable to match requested speed 2000 kHz, using 1800 kHz
Info : Stlink adapter speed set to 1800 kHz
Info : STM32F769.cpu: hardware has 8 breakpoints, 4 watchpoints
Info : Listening on port 3333 for gdb connections
```
  
And the glorious red/green blinking LED sequence is seen on the discovery kit, and I can issue a reset halt command!  Yay, moving on.  
  
**Reading the flash, writing the flash, verifying the flash, building the Demo source and flashing it.**
  
```
telnet localhost 4444
> flash read_bank 0 /tmp/flashbank0
flash size probed value 2048
wrote 2097152 bytes to file /tmp/flashbank0 from flash bank 0 at offset 0x00000000 in 20.523928s (99.786 KiB/s)
```
  
Indeed, we've read 2M of flash.  Here goes nothing!!!  
Yessss, I did not brick the board.  
  
```
> halt
target halted due to debug-request, current mode: Thread 
xPSR: 0x41000000 pc: 0x0806b398 psp: 0x20013a98
> flash erase_sector 0 0 last
erased sectors 0 through 11 on flash bank 0 in 8.665847s
> reset
``` 
  
First halt the target, then erase all of bank 0, then reset.  The touchscreen becomes unresponsive and the image frozen.  Resetting does not update the image.  Resetting immediately sends the target into a HardFault.  Good. 

```  
> flash write_bank 0 /tmp/flashbank0     
target halted due to breakpoint, current mode: Handler HardFault
xPSR: 0x61000003 pc: 0x20000084 msp: 0xffffffd8
wrote 2097152 bytes from file /tmp/flashbank0 to flash bank 0 at offset 0x00000000 in 22.732296s (90.092 KiB/s)
> 
> reset
```
  
And the board is back online with the same application!
  
Now let's make sure the binary we have from ST matches the one that is loaded on the target.  
We have 2 binaries included here:  
```
steve@McBain:~/prog/embedded/STM32Cube_FW_F7_V1.15.0/Projects/STM32F769I-Discovery/Demonstrations/STemWin/Binary $$$ l
total 143M
-rw-rw-r-- 1 steve steve  27M Feb  7  2019 STM32CubeDemo_STM32769I-DISCO_V1.4.0.hex
-rw-rw-r-- 1 steve steve 117M Feb  7  2019 STM32769I-DISCO_DEMO_V1.0.0_FULL.hex
```
  
The one ending with `_FULL` is the one preloaded, which has extra 3rd party stuff.  The other one is for the included source code project.  
  
Hmm having some issues with `hex2bin` and `objcopy`, unable to verify the HEX equals the binary.  
The HEX file is 117M big, meaning it must be storing some data like images or video.  
Perhaps that threw off the hex2bin conversion.  
  
Anyway I'm going to move on and now try to build the provided demo project and flash it.  
  
Jeez, the OpenOCD interface is buggy AF!  I have to manually power cycle the board every time.
It takes 50 seconds to flash wow.  Putting the target 1 USB hub deep instead of 2 helps.  
Should not have put it 2 hubs deep.  
  
OK now I'm reasonably in control of the target.  The first experiment I did was to remove some of the modules (ie. "apps"), and see that I can rebuild, reflash and see the difference on the screen.
  
This should be a good starting point.  My plan is to copy one of the modules and use it as
the starting point for my new module, an audio processor module.  It'll use pieces of the
Audio Recorder and Audio Playback modules.  Eventually I'll have to dig deeper in the
example applications to get stuff like USB connectivity, GPIO, etc.
  
Oh goodness I am raging, this tool is a joke.  I'll never let an IDE build my code ever again!!  
Does a clean build almost every time, taking nearly 2 minutes.  
The .project file does all sorts of filesystem crap.  Copying stuff into an "Application" folder?  Wat?  
Thank goodness I use git, otherwise I wouldn't be able to see the crap that's happening behind my back. Oh my god, randomly adding ^M carriage returns.  (this could be an eclipse issue).
  
Literally I can't even make sense of what happens when I right click, "Add New Source Folder" , "Add New Source File", copy paste an existing source file in there.  The include directories are not the same.  I will never depend on a shit IDE (ie. not IntelliJ) for my build configuration, EVER!  
  
  
To free myself from this absolutely egregious vendor lock-in, I will run a clean build and save all of the console output.  This will give me an idea of what compiler flags, include directories, static libraries, etc are used.  Generally I wouldn't need this information but I have negative trust here, in that I trust that there will be tricks and booby traps in this codebase.  

  

