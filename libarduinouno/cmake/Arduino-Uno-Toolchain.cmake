function(setup_compilers)
    # Find ASM compiler
    find_program(CMAKE_ASM_COMPILER avr-gcc)
    if (NOT CMAKE_ASM_COMPILER OR ${CMAKE_ASM_COMPILER} STREQUAL "")
        message(FATAL_ERROR "avr-gcc program is required by the toolchain but can't be found")
    endif ()

    # Find C compiler
    find_program(CMAKE_C_COMPILER avr-gcc)
    if (NOT CMAKE_C_COMPILER OR ${CMAKE_C_COMPILER} STREQUAL "")
        message(FATAL_ERROR "avr-gcc program is required by the toolchain but can't be found")
    endif ()

    # Find C++ compiler
    find_program(CMAKE_CXX_COMPILER avr-g++)
    if (NOT CMAKE_CXX_COMPILER OR ${CMAKE_CXX_COMPILER} STREQUAL "")
        message(FATAL_ERROR "avr-g++ program is required by the toolchain but can't be found")
    endif ()

endfunction()

function(setup_avr_tools)

    # Find AR required for linkage
    find_program(CMAKE_AR avr-gcc-ar)
    if (NOT CMAKE_AR OR ${CMAKE_AR} STREQUAL "")
        message(FATAL_ERROR "avr-gcc-ar program is required by the toolchain but can't be found")
    endif ()

    # Find Ranlib required for linkage
    find_program(CMAKE_RANLIB avr-gcc-ranlib)
    if (NOT CMAKE_RANLIB OR ${CMAKE_RANLIB} STREQUAL "")
        message(FATAL_ERROR "avr-gcc-ranlib program is required by the toolchain but can't be found")
    endif ()

    # Find NM
    find_program(CMAKE_NM avr-gcc-nm)
    if (NOT CMAKE_NM OR ${CMAKE_NM} STREQUAL "")
        message(FATAL_ERROR "avr-objcopy program is required by the toolchain but can't be found")
    endif ()

    # Find avr-objcopy
    find_program(CMAKE_AVROBJCOPY_PROGRAM avr-objcopy)
    if (NOT CMAKE_AVROBJCOPY_PROGRAM OR ${CMAKE_AVROBJCOPY_PROGRAM} STREQUAL "")
        message(FATAL_ERROR "avr-objcopy program is required by the toolchain but can't be found")
    endif ()

    # Find avrdude
    find_program(CMAKE_AVRDUDE_PROGRAM avrdude)
    if (NOT CMAKE_AVRDUDE_PROGRAM OR ${CMAKE_AVRDUDE_PROGRAM} STREQUAL "")
        message(FATAL_ERROR "avrdude program is required by the toolchain but can't be found")
    endif ()

    # Find avr-size
    find_program(CMAKE_AVRSIZE_PROGRAM avr-size)
    if (NOT CMAKE_AVRSIZE_PROGRAM OR ${CMAKE_AVRSIZE_PROGRAM} STREQUAL "")
        message(FATAL_ERROR "avrdude program is required by the toolchain but can't be found")
    endif ()

    # Find avr-objdump
    find_program(CMAKE_AVROBJDUMP_PROGRAM avr-objdump)
    if (NOT CMAKE_AVROBJDUMP_PROGRAM OR ${CMAKE_AVROBJDUMP_PROGRAM} STREQUAL "")
        message(FATAL_ERROR "avr-objdump program is required by the toolchain but can't be found")
    endif ()

endfunction()

##################################################################################
# set compiler options for build types
##################################################################################
#if(CMAKE_BUILD_TYPE MATCHES Release)
#    set(CMAKE_C_FLAGS_RELEASE "-Os")
#    set(CMAKE_CXX_FLAGS_RELEASE "-Os")
#endif(CMAKE_BUILD_TYPE MATCHES Release)
#
#if(CMAKE_BUILD_TYPE MATCHES RelWithDebInfo)
#    set(CMAKE_C_FLAGS_RELWITHDEBINFO "-Os -save-temps -g -gdwarf-3 -gstrict-dwarf")
#    set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "-Os -save-temps -g -gdwarf-3 -gstrict-dwarf")
#endif(CMAKE_BUILD_TYPE MATCHES RelWithDebInfo)
#
#if(CMAKE_BUILD_TYPE MATCHES Debug)
#    set(CMAKE_C_FLAGS_DEBUG "-O0 -save-temps -g -gdwarf-3 -gstrict-dwarf")
#    set(CMAKE_CXX_FLAGS_DEBUG "-O0 -save-temps -g -gdwarf-3 -gstrict-dwarf")
#endif(CMAKE_BUILD_TYPE MATCHES Debug)

##########################################################################
# Set up compilers and avr tools
##########################################################################

#
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR avr)

#
setup_compilers()
setup_avr_tools()

##########################################################################
# Set up board settings
##########################################################################

#
set(AVR_MCU "atmega328p")

#
set(AVR_H_FUSE "0xde")
set(AVR_L_FUSE "0xff")
set(AVR_E_FUSE "0xfd")

#
set(MCU_SPEED "16000000L")

#
set(ARDUINO_VERSION 10807)

#
#set(AVR_PROGRAMMER "arduino")

#
#set(AVR_UPLOADTOOL_PORT "/dev/tty.usbmodem14101")