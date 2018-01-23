---
layout: post
title: 'CMake: Building an App for Multiple Targets'
---
I have an application, it's a sniffer.  
I want it to run on bare metal, on an OS, and on multiple CPU targets.  
Basically anything with a SPI port and the radio should be able to run this.  
OK, looks like it worked.  Here's what I learned:  
  
```
steve@steve-ThinkPad-T420:~/prog/debos/debos_sniffer$ tree
.
├── build.sh
├── CMakeLists.txt
├── Makefile
├── platform
│   ├── CMakeLists.txt
│   ├── samd20_baremetal
│   └── samd20_debos
│       ├── atsamd20j18.ld
│       ├── CMakeLists.txt
│       └── halStartup.c
├── README.md
├── src
│   ├── app.c
│   ├── my_memcpy.c
│   ├── my_memcpy.h
│   └── System.h
└── tool
    ├── sniffer_parser_lwmesh.py
    └── sniffer_reader.py
```
```
#### The Top Level CMakeLists.txt
cmake_minimum_required(VERSION 3.5)

add_subdirectory(platform)
```
```
#### The platform/ CMakeLists.txt
add_subdirectory(samd20_debos)
```
  
Now, here's where all the original stuff went.  platform/samd20_debos CMakeLists.txt.  I made a few modifications to it.  
  
First notice in the tree, that I have halStartup.c inside of platform/, not src/.  This is because halStartup.c is platform specific; it defines the vector table, startup code, etc.  In the case of the bootloaded (debos) version, the startup code is actually dummy, and it is just there to help the linker create the binary image correctly.  But for the bare metal version, the startup code needs to be correct and actually call the main()  while(1)
  
src/ only has app.c , which currently does depend on a SAMD20 specific library.  We'll take care of that later.

```
#set(CMAKE_BINARY_DIR ${CMAKE_SOURCE_DIR}/bin)
#set(EXECUTABLE_OUTPUT_PATH ${CMAKE_BINARY_DIR})
#set(LIBRARY_OUTPUT_PATH ${CMAKE_BINARY_DIR})
```
I commented those out, I need to figure out whether I'm supposed to set them myself, or use the preset values.  I did notice that setting CMAKE_BINARY_DIR causes the built binaries to show up there, which is what I want.  

```
 add_custom_command(TARGET debos_sniffer POST_BUILD
-    COMMAND size bin/debos_sniffer
+    COMMAND size debos_sniffer
 )
```
Here's another interesting one.  Before when CMAKE_BINARY_DIR was set to ${CMAKE_SOURCE_DIR}/bin, the custom command worked by specifying bin/debos_sniffer.  This is bin/ at the top level, where .git/ is.  But now, the compiled binary shows up in build/platform/samd20_debos/ , and somehow it is found by just specifying debos_sniffer.

``` +#file(GLOB SOURCES
+#    "*.h"
+#    "*.c"
+#    "hal/*.c"
+#    "hal/*.h"
+#)
+
+set(SOURCES   ${CMAKE_SOURCE_DIR}/src/app.c
+							${CMAKE_SOURCE_DIR}/src/my_memcpy.c 
+	 ) 
+
```
Here you see I replaced file(GLOB SOURCES ...) with set(SOURCES ...),
as recommended by people.  Notice I'm specifying more exactly where the source is; the previous file(GLOB SOURCES ...) worked when CMakeLists.txt was inside the directory with the source.
