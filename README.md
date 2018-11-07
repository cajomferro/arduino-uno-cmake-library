# Arduino Uno library using effective CMake guidelines

This is a sample project of how you can build a regular C/C++ library of the Arduino Uno by using CMake and import it from an executable. There other projects that already use Arduino with CMake but they rather do not follow the Effective Modern CMake guidelines or are too much complex (for my needs) and still depend on an Arduino installation on the local filesystem.

This sample uses Arduino 1.8.7 version library source files. All rights are reserved to Arduino. This is just a demonstration of how to use them as a CMake library.

## How to compile this library

### Installing on Unix


Run the following commands inside the "libarduinouno" folder:

    $: mkdir -p build/cmake-build-arduinouno
    $: cd cmake-build-arduinouno
    $: cmake -DCMAKE_TOOLCHAIN_FILE=cmake/Arduino-Uno-Toolchain.cmake -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON -DAVR_UPLOADTOOL_PORT:STRING="/dev/tty.usbmodem14101" -DAVR_PROGRAMMER:STRING="arduino" ../
    $: make

Change AVR_UPLOADTOOL_PORT and AVR_PROGRAMMER depending on your needs.

Optionally, you can test your board with this library by running the same command inside "example_exec".

## Projects that inspired this work

### Effective Modern CMake
* https://github.com/pabloariasal/modern-cmake-sample
* https://gist.github.com/mbinna/c61dbb39bca0e4fb7d1f73b0d66a4fd1
* https://cliutils.gitlab.io/modern-cmake/chapters/basics/functions.html

### CMake AVR
* https://github.com/mkleemann/cmake-avr

### CMake Arduino
* https://github.com/queezythegreat/arduino-cmake
* https://github.com/arduino-cmake/Arduino-CMake-NG
* https://github.com/cpbotha/arduino-clion-minimal
* https://github.com/ChisholmKyle/ArduinoCMake