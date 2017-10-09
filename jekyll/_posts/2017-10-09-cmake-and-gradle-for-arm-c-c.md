---
layout: post
title: CMake and Gradle for ARM C/C++
---
  
I'm trying to build my codebase in CMake or Gradle.  
Tried Gradle first.  At first glance there are way too many DSL keywords,
I have no idea what they do and connecting the dots is insane.  
It's the same frustration I get with python.  Never knowing what type anything is
and always having to look up documentation before writing a single line.
  
Now trying CMake...
  
http://derekmolloy.ie/hello-world-introductions-to-cmake/
  
I started with this CMakeLists.txt
```
cmake_minimum_required(VERSION 2.8)
project(hello)
set(CMAKE_BINARY_DIR ${CMAKE_SOURCE_DIR}/bin)
set(EXECUTABLE_OUTPUT_PATH ${CMAKE_BINARY_DIR})
set(LIBRARY_OUTPUT_PATH ${CMAKE_BINARY_DIR})
include_directories("${PROJECT_SOURCE_DIR}")
add_executable(hello ${PROJECT_SOURCE_DIR}/src/main.c)
```
  
To build,
```
cmake .
make
```
  
Wow it actually tried to compile something.  No include directories were supplied.  Let's add one.
```
include_directories(myincludedir)
```
Works.  Now there's another header that's not inside the repo.  
Let's add those.
  
```
include_directories("../samd20_cmsis_headers")
include_directories("../arm_cmsis_headers")
```

Next error, Error: no such instruction: `cpsie i'.  
I must not be compling with the arm gcc compiler.  
```
set(CMAKE_C_COMPILER arm-none-eabi-gcc)
```
  
```
arm-none-eabi-gcc: error: unrecognized command line option '-rdynamic'
```
  
Now I get this error.  Found a solution from here.  
```
https://github.com/digitalbitbox/mcu/blob/master/arm.cmake
# Avoid known bug in linux giving: 
#    arm-none-eabi-gcc: error: unrecognized command line option '-rdynamic'
set(CMAKE_SHARED_LIBRARY_LINK_C_FLAGS "")
```
  
For the CFLAGS I used this syntax.
```
set(CMAKE_C_FLAGS "-std=c99                      ")
string(APPEND CMAKE_C_FLAGS "-Wall                         ")
string(APPEND CMAKE_C_FLAGS "-Wextra                       ")
```
  
I used this to add directories containing source files to be compiled.
```
file(GLOB SOURCES
    "src/*.h"
    "src/*.c"
    "src/hal/*.c"
    "src/hal/*.h"
)
```
And I changed the executable to be built from those sources:
```
add_executable(myname ${SOURCES})
```
  

