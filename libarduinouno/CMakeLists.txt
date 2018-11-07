cmake_minimum_required(VERSION 3.12)
project(libarduino VERSION 1.0.0 LANGUAGES C CXX ASM)

#Make sure that custom modules like FindRapidJSON are found
list(INSERT CMAKE_MODULE_PATH 0 ${CMAKE_SOURCE_DIR}/cmake)

##########################################################################
# Arduino C++ library
##########################################################################

add_library(arduinocxx
        src/HardwareSerial.cpp
        src/HardwareSerial0.cpp
        src/HardwareSerial1.cpp
        src/HardwareSerial2.cpp
        src/HardwareSerial3.cpp
        src/IPAddress.cpp
        src/PluggableUSB.cpp
        src/Print.cpp
        src/Stream.cpp
        src/Tone.cpp
        src/USBCore.cpp
        src/WMath.cpp
        src/WString.cpp
        src/abi.cpp
        src/new.cpp
        )

#Add an alias so that library can be used inside the build tree, e.g. when testing
add_library(PekoeVM::arduinocxx ALIAS arduinocxx)

#Set target properties
target_include_directories(arduinocxx
        PUBLIC
        $<INSTALL_INTERFACE:include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/src
        )

target_compile_features(arduinocxx PRIVATE cxx_auto_type)

# compiler.cpp.flags=-c -g -Os {compiler.warning_flags} -std=gnu++11 -fpermissive -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -Wno-error=narrowing -MMD -flto

target_compile_options(arduinocxx
        PRIVATE
        -g -Os -w -fpermissive -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -Wno-error=narrowing -MMD -flto -mmcu=${AVR_MCU}
        )

target_compile_definitions(arduinocxx
        PRIVATE
        ARDUINO=${ARDUINO_VERSION} ARDUINO_AVR_UNO ARDUINO_ARCH_AVR F_CPU=${MCU_SPEED}
        )

set_target_properties(arduinocxx
        PROPERTIES
        CXX_EXTENSIONS ON
        )

##########################################################################
# Arduino C library
##########################################################################

add_library(arduinoc
        src/WInterrupts.c
        src/hooks.c
        src/wiring.c
        src/wiring_analog.c
        src/wiring_digital.c
        src/wiring_pulse.c
        src/wiring_shift.c
        )

#Add an alias so that library can be used inside the build tree, e.g. when testing
add_library(PekoeVM::arduinoc ALIAS arduinoc)

#Set target properties

target_include_directories(arduinoc
        PUBLIC
        $<INSTALL_INTERFACE:include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/src
        )

# compiler.c.flags=-c -g -Os {compiler.warning_flags} -std=gnu11 -ffunction-sections -fdata-sections -MMD -flto -fno-fat-lto-objects

target_compile_options(arduinoc
        PRIVATE
        -g -Os -w -ffunction-sections -fdata-sections -MMD -flto -fno-fat-lto-objects -mmcu=${AVR_MCU}
        )

# For more info on ARDUINO_ARCH_AVR: https://github.com/arduino/arduino/wiki/arduino-ide-1.5:-library-specification
target_compile_definitions(arduinoc
        PRIVATE
        ARDUINO=${ARDUINO_VERSION} ARDUINO_AVR_UNO ARDUINO_ARCH_AVR F_CPU=${MCU_SPEED}
        )

set_target_properties(arduinoc
        PROPERTIES
        C_STANDARD 11 # SHOULD WE FORCE THIS?! ARDUINO HAS THIS
        C_STANDARD_REQUIRED ON
        C_EXTENSIONS ON
        )


##########################################################################
# Arduino ASM library
##########################################################################

add_library(arduinoasm
        src/wiring_pulse.S
        )

#Add an alias so that library can be used inside the build tree, e.g. when testing
add_library(PekoeVM::arduinoasm ALIAS arduinoasm)

#Set target properties
target_include_directories(arduinoasm
        PUBLIC
        $<INSTALL_INTERFACE:include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/src
        )

# compiler.S.flags=-c -g -x assembler-with-cpp -flto -MMD
# -c -g -x assembler-with-cpp -flto -MMD -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10807 "-DARDUINO_AVR_UNO "

target_compile_options(arduinoasm
        PRIVATE
        -g -x assembler-with-cpp -flto -MMD -mmcu=${AVR_MCU}
        )

target_compile_definitions(arduinoasm
        PRIVATE
        ARDUINO=${ARDUINO_VERSION} ARDUINO_AVR_UNO ARDUINO_ARCH_AVR F_CPU=${MCU_SPEED}
        )


##########################################################################
# Link libraries
##########################################################################

target_link_libraries(arduinocxx
        PUBLIC
        arduinoc
        arduinoasm
        )

##############################################
# Installation instructions

include(GNUInstallDirs)
set(INSTALL_CONFIGDIR ${CMAKE_INSTALL_LIBDIR}/cmake/pekoevmarduino)

install(TARGETS arduinocxx arduinoc arduinoasm
        EXPORT pekoevmarduino-export
        LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
        ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
        )

#This is required so that the exported target has the name PekoeVM and not pekoevm
set_target_properties(arduinocxx PROPERTIES EXPORT_NAME PekoeVMArduino)

install(DIRECTORY include/ DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

#Export the targets to a script
install(EXPORT pekoevmarduino-export
        FILE
        pekoevmarduino-install.cmake
        NAMESPACE
        PekoeVM::
        DESTINATION
        ${INSTALL_CONFIGDIR}
        )

#Create a ConfigVersion.cmake file
include(CMakePackageConfigHelpers)
write_basic_package_version_file(
        ${CMAKE_CURRENT_BINARY_DIR}/pekoevmarduino-config-version.cmake
        VERSION ${PROJECT_VERSION}
        COMPATIBILITY AnyNewerVersion
)

configure_package_config_file(${CMAKE_CURRENT_LIST_DIR}/cmake/pekoevmarduino-config.cmake.in
        ${CMAKE_CURRENT_BINARY_DIR}/pekoevmarduino-config.cmake
        INSTALL_DESTINATION ${INSTALL_CONFIGDIR}
        )

#Install the config, configversion and custom find modules
install(FILES
        #        ${CMAKE_CURRENT_LIST_DIR}/cmake/FindRapidJSON.cmake
        ${CMAKE_CURRENT_BINARY_DIR}/pekoevmarduino-config.cmake
        ${CMAKE_CURRENT_BINARY_DIR}/pekoevmarduino-config-version.cmake
        DESTINATION ${INSTALL_CONFIGDIR}
        )

export(EXPORT pekoevmarduino-export FILE ${CMAKE_CURRENT_BINARY_DIR}/pekoevmarduino-install.cmake NAMESPACE PekoeVM::)

#Register package in user's package registry
export(PACKAGE PekoeVMArduino)
