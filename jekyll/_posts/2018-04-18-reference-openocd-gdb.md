---
layout: post
title: 'Reference:  OpenOCD, GDB'
---

<link rel="stylesheet" href="https://2ab9pu2w8o9xpg6w26xnz04d-wpengine.netdna-ssl.com/wp-content/cache/autoptimize/css/autoptimize_f0ba07fcfbfb99eca6dd6305271724f8.css"/>
# OpenOCD Pre-reqs
* Host:  Laptop or Beaglebone, with openocd installed, with some USB programmer
* openocd.cfg files: repo
#### To start OpenOCD, cd to directory with openocd.cfg, run `openocd`

# GDB Commands   
* Start GDB, with an ELF file if you want.  `gdb example.elf`
* Should work on the Beaglebone native gdb, because it is ARM, difference is eabihf vs eabi
* `(gdb) target remote localhost:3333`
* `monitor reset` , `monitor halt` , `monitor reset halt` 
* `monitor` actually issues OpenOCD commands thru GDB.
#### To verify an ELF file:  
#### `monitor verify_image /full/path/to/my.elf`  
Actually the search path is the directory that OpenOCD started in.
#### To load an ELF file into flash memory:  
#### `monitor flash write_image erase /full/path/to/my.elf`  
#### Use the erase parameter, to erase before writing.  According to openocd manual, you should assume other flash sectors will be erased too.
* To start gdb connected to remote target:  `gdb -ex "target remote localhost:3333" ~/my.elf`
  
# Telnet Commands
#### Load Image Automatically
```
#!/bin/bash
fetch_and_load()
  {
    ls $v1 2>/dev/null || wget ffn.bootladder.com:9001/$v1

    (echo reset halt; sleep 1) | telnet localhost 4444
    sleep 2
    (echo flash write_image erase $(pwd)/$v1 ; sleep 1) | telnet localhost 4444
    sleep 2
    (echo reset; sleep 1) | telnet localhost 4444
}

v1=$(curl ffn.bootladder.com:9001/target/ffnbeagle-woodland-stm32discovery)
ls $v1 2>/dev/null || fetch_and_load
```
This appears to work, but not sure if it works every time.  Hence the sleeps.
