---
layout: post
title: OpenOCD Target Practice
---

# SAMD20 Custom Board with Atmel-ICE
```
# Atmel-ICE JTAG/SWD in-circuit debugger.
interface cmsis-dap
cmsis_dap_vid_pid 0x03eb 0x2141

# Chip info
set CHIPNAME at91samd20j18
source [find target/at91samdXX.cfg]
```
This is the output from lsusb -v:  
```
Bus 001 Device 002: ID 03eb:2141 Atmel Corp. 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass          239 Miscellaneous Device
  bDeviceSubClass         2 ?
  bDeviceProtocol         1 Interface Association
  bMaxPacketSize0        64
  idVendor           0x03eb Atmel Corp.
  idProduct          0x2141 
  bcdDevice            1.01
  iManufacturer           1 Atmel Corp.
  iProduct                2 Atmel-ICE CMSIS-DAP
  iSerial                 3 J41800075898
```
Let's just see what happens if I change those IDs.  Interesting, it still works fine, even if I delete the whole line cmsis_dap_vid_pid 0x03eb 0x2141.  
Next with that whole line deleted, I put a spelling mistake,  
`interface cmsis-dapABC`
```
Open On-Chip Debugger 0.8.0 (2014-10-20-23:18)
Licensed under GNU GPL v2
For bug reports, read
	http://openocd.sourceforge.net/doc/doxygen/bugs.html
Error: The specified debug interface was not found (cmsis-dapz)
The following debug interfaces are available:
1: parport
2: dummy
3: ftdi
4: usb_blaster
5: amt_jtagaccel
6: ep93xx
7: at91rm9200
8: gw16012
9: usbprog
10: jlink
11: vsllink
12: rlink
13: ulink
14: arm-jtag-ew
15: buspirate
16: remote_bitbang
17: hla
18: osbdm
19: opendous
20: aice
21: bcm2835gpio
22: cmsis-dap
Runtime Error: incorrect_openocd.cfg:2: 
in procedure 'script' 
at file "embedded:startup.tcl", line 58
in procedure 'interface' called at file "incorrect_openocd.cfg", line 2
```
So here we see the "Interfaces" we can choose.  
Next I examined the Chip Info.  
Deleting the line  `set CHIPNAME at91samd20j18` had no change, even setting the name to a bogus value did not affect anything.  
So clearly the important lines are 
```
interface cmsis-dap
source [find target/at91samdXX.cfg]
```
So, what is inside target/at91samdXX.cfg ?  
```
#
# samdXX devices only support SWD transports.
#
source [find target/swj-dp.tcl]
```
OK, what is SWJ-DP ?  What is SWJ?  Let's see the file.  
```
# ARM Debug Interface V5 (ADI_V5) utility
# ... Mostly for SWJ-DP (not SW-DP or JTAG-DP, since
# SW-DP and JTAG-DP targets don't need to switch based
# on which transport is active.
...
...
if [catch {transport select}] {
  echo "Error: unable to select a session transport. Can't continue."
  shutdown
}

proc swj_newdap {chip tag args} {
 if [using_hla] {
     eval hla newtap $chip $tag $args
 } elseif [using_jtag] {
     eval jtag newtap $chip $tag $args
 } elseif [using_swd] {
     eval swd newdap $chip $tag $args
 }
}
```
The comment at the top explains, SWJ is for debug interfaces that support both JTAG and SWD.  My Atmel-ICE is one of those.  
proc swj_newdap is just a switch to select the command, in my case it would be using_swd so `eval swd newdap $chip $tag $args`.  
Hmm where is `using_swd` defined, and what is `swd newdap` ?  
Back to at91samdXX.cfg , we see this line:
```
swj_newdap $_CHIPNAME cpu -irlen 4 -expected-id $_CPUTAPID

set _TARGETNAME $_CHIPNAME.cpu
target create $_TARGETNAME cortex_m -endian $_ENDIAN -chain-position $_TARGETNAME

$_TARGETNAME configure -work-area-phys 0x20000000 -work-area-size $_WORKAREASIZE -work-area-backup 0
```
swj_newdap takes 3 args, chip tag args.  What's a tag?  Whatever.  
Then there's `target create $_TARGETNAME ...`  
We're configuring a cortex_m CPU with endianness.  
Then configuring it with a RAM work area?  don't know what that's for... does it clobber app ram?
  
Then at the end there's this:
```
set _FLASHNAME $_CHIPNAME.flash
flash bank $_FLASHNAME at91samd 0x00000000 0 1 1 $_TARGETNAME
```
I guess we are supplying this information to GDB?



# SAMD20 Custom Board with SAMD20 XPlained Pro
# SAMD20 XPlained Pro Self
# SAMD10 XPLained
# SAMD21 XPLained
# Arduino Leo
