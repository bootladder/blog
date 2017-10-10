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
  
I noticed the output of the GNU size command shows different sizes for the
ELF output from the CMake build and the original Makefile build.
  I realized I never specified the linker script.  Let's do that.
  
Turns out I just stick it in the CMAKE_C_FLAGS , no need for a separate linker flags.
  
Added that and I get the desired output.
```
   text    data     bss     dec     hex filename     
  3352      68    2584    6004    1774 bin/debos_firmware  
```
  
Seeing that exact same output on either build is... extremely releiving.
  
# Uh, now I'm trying to build my unit test executable.
  
I got this far ...
```
file(GLOB TEST_SOURCES
    "test/*.h"
    "test/*.c"
    "test/test_runners/*.c"
    "test/test_runners/*.h"
    "mock/*.c"
    "../Unity/src/*.c"
    "src/*.c"
    "src/hal/*.c"
)
```
  
First issue I have to deal with:  
Multiple Definition error from the linker.  
As you see, I included the test/ directory and src/.
Inside test there are some mocked objects.  The names collide with the ones from source.  
  
A solution I've learned from various books is to compile the source into a library.
When linking the test executable, the library will only be searched when the
symbol is not found in the test objects.  
This hackish technique creates a priority of sorts, for names.  Test names first, production names second.  

  
Now how do I do this with CMake?  Reimplement that above logic?  
My guess is Yes, because CMake just wraps make and it is make and gcc that are complaining
about not finding the symbols.  
