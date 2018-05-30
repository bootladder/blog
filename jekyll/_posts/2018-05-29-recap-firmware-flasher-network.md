---
layout: post
title: 'Recap: Firmware Flasher Network'
---
# Materials:
* Beaglebone (or other device with Ethernet and USB)
* Some device or method for bridging Beaglebone to LAN (eg. Laptop)
* Targets (eg. Microcontrollers)
* Target Interface Hardware (eg. JTAG dongles, FTDIs, serial ports, GPIOs)
* Target Interface Software (eg. OpenOCD, Vendor Bootloader, Custom)
* USB Hubs

# First get access to your Manager (Beaglebone)
**Options**:  
* Reverse SSH Tunnel
* VPN
* LAN Access
  
LAN Access is the easiest to get moving along but it will not allow full automation of the CI/CD pipeline.  Let's use it for now.  
  
# Set up the tools for accessing the targets
What you want is a set of shell scripts.  
A script will get a firmware image and drive the target interface to load the image to the target.  
Image path can be a URL to wget, or a path in the local filesystem.  If the path is local, there needs to be a way to download the files to the local filesystem first.
Some type of output should appear in stdout.
  
This part takes some manual configuration.  For this, I will SSH into the Manager (Beaglebone) and see that everything is configured.
  
# Hook up the Git --> Jenkins --> Publish pipeline
When you push commits to the remote git repo, that should trigger
builds on Jenkins, and Jenkins will publish the binaries
to places that the above shell scripts can access.
  
# Now you have to trigger the Deployment
If you didn't set up a VPN or reverse SSH tunnel for your Beaglebone (Manager) , you have to manually trigger the Beaglebone to fetch and deploy.
  
# Done!  
# Now here is an example:
  
The example I want to demo is a FreeRTOS LED Blink Application.  
I want this to run on various target hardware, including
development boards and custom boards, with different microcontrollers on them.  I want a git push to trigger a build for each of these targets, and then I want to be able to deploy to each target, individually or all at the same time.


The Application source code will contain:  
* FreeRTOS, including ports for all targets.
* LED Blink Init and Driver code for each supported target.
* Application Code: Initializes and Starts the Blink Task.
  
# The challenging part:  Set up this software project!
* Portable Application Code
    * Should use Interfaces to HW and not have knowledge of target platform.
    * Interfaces such as HW_Init(), Led_1_On(), Led_1_Blink().
* Multi-Target Build System
    * The CMake script should specify all targets, instead of multiple CMake scripts, or using git branches per target.
    * eg. make arduino-due , make stm32f4discovery , make my-custom-board
    * Select FreeRTOS files to build
    * Select Linker Script
    * Generate SemVer Name:  blink-0.3.21-stm32f4discovery+ab12cd34.elf
  

