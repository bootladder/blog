---
layout: post
title: Debugging a Bootloader with GDB and OpenOCD
---
I have a working build of a bootloader.  Let's flash it.  I have a binary and an ELF.  First let's flash the binary.  
I'm using a SAMD20 custom board with an Atmel-ICE driven by a Beaglebone running OpenOCD, and I'm driving the Beaglebone with SSH.
Let's configure the Beaglebone's OpenOCD conf.

**Hmm, arm-none-eabi gcc and gdb are 700mb disk.  No thanks?**  
Let's see what we can do with telnet.
```
telnet localhost 4444
```
Cool, halt and reset work.  
To read some memory use these
```
> mdw 0x3ff00
0x0003ff00: 2110002a 
```
Let's load an image
```
> load_image /tmp/binarg1
8180 bytes written at address 0x00000000
downloaded 8180 bytes in 0.327776s (24.371 KiB/s)
> reset  
```
Looks like it worked.  Interestingly there is no LED toggle on the debugger.  I guess edbg puts it in but OpenOCD doesn't.  

Let's look at the vector table.
```
> dump_image /tmp/bindump1 0x0 0x100
dumped 256 bytes in 0.011345s (22.036 KiB/s)
-------
-------
debian@FFNBeagle-A-0:/tmp$ od -tx1 -w4 -Ax bindump1 -v
000000 00 80 00 20
000004 25 07 00 00
000008 65 07 00 00
00000c 0d 07 00 00
000010 00 00 00 00
000014 00 00 00 00
000018 00 00 00 00
00001c 00 00 00 00
000020 00 00 00 00
000024 00 00 00 00
000028 00 00 00 00
00002c 65 07 00 00
000030 00 00 00 00
000034 00 00 00 00
000038 65 07 00 00
00003c 65 07 00 00
000040 65 07 00 00
000044 65 07 00 00
000048 65 07 00 00
00004c f1 06 00 00
000050 fd 05 00 00
```
