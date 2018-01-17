---
layout: post
title: arduino-cmake first try
---
I cloned the repo.
```
cd example
mkdir build
cmake ..
CMake Error at CMakeLists.txt:11 (GENERATE_ARDUINO_LIBRARY_EXAMPLE):
  Unknown CMake command "GENERATE_ARDUINO_LIBRARY_EXAMPLE".
```
OK `https://github.com/queezythegreat/arduino-cmake/issues/38` solves it.  
mkdir build;cmake .. must happen in the top level CMakeLists.txt directory.  
```
steve@steve-ThinkPad-T420:~/prog/scratch/arduino-cmake$ mkdir build
steve@steve-ThinkPad-T420:~/prog/scratch/arduino-cmake$ cd build
steve@steve-ThinkPad-T420:~/prog/scratch/arduino-cmake/build$ cmake ..
CMake Error at cmake/ArduinoToolchain.cmake:93 (message):
  Could not find Arduino SDK (set ARDUINO_SDK_PATH)!
Call Stack (most recent call first):
  /usr/share/cmake-3.5/Modules/CMakeDetermineSystem.cmake:98 (include)
  CMakeLists.txt:15 (project)
```
OK, it can't find the toolchain.  It's not installed.  What happened ...  
Line 15 of the top level CMakeLists.txt, was a project() call.  
```
project(ArduinoExample C CXX ASM)
```
And then project() calls CMake core... line 98
```
     include("${CMAKE_TOOLCHAIN_FILE}" OPTIONAL RESULT_VARIABLE _INCLUDED_TOOLCHAIN_FILE)
```
`CMAKE_TOOLCHAIN_FILE` is set in the CMakeLists.txt: 
```
#=============================================================================#
# Author: QueezyTheGreat                                                      #
# Date:   26.04.2011                                                          #
#                                                                             #
# Description: Arduino CMake example                                          #
#                                                                             #
#=============================================================================#
set(CMAKE_TOOLCHAIN_FILE cmake/ArduinoToolchain.cmake) # Arduino Toolchain


cmake_minimum_required(VERSION 2.8)
#====================================================================#
#  Setup Project                                                     #
#====================================================================#
project(ArduinoExample C CXX ASM)

print_board_list()
print_programmer_list()

add_subdirectory(example)   #add the example directory into build
~                                                                     
```
So we are reading the ArduinoToolchain.cmake. 
Some interesting things inside here, some I don't understand.  
```
set(CMAKE_SYSTEM_NAME Arduino)

set(CMAKE_C_COMPILER avr-gcc)
set(CMAKE_ASM_COMPILER avr-gcc)
set(CMAKE_CXX_COMPILER avr-g++)
``` 
Here we are identifying avr-gcc, that's cool.  
```
#=============================================================================#
#                         System Paths                                        #
#=============================================================================#
if (UNIX)
    include(Platform/UnixPaths)
```
include() is like #include in C, so let's see it.  Huh.. it's not there.  Let's see later then...  
  
Then there's a part later to detect the `ARDUINO_SDK_PATH` using hints, which are directories likely to have the install.  
Let's just install the SDK now.



