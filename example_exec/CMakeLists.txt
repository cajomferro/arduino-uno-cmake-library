cmake_minimum_required(VERSION 3.12)
project(example_exec-elf VERSION 1.0.0 LANGUAGES C CXX)

##############################################
# Create target and set properties

# elf file
add_executable(example_exec-elf
        EXCLUDE_FROM_ALL
        src/main)

target_compile_features(example_exec-elf
        PRIVATE
        cxx_auto_type
        )

target_compile_options(example_exec-elf
        PRIVATE
        -g -Os -w -fpermissive -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -Wno-error=narrowing -MMD -flto -mmcu=${AVR_MCU}
        )

target_compile_definitions(example_exec-elf
        PRIVATE
        F_CPU=${MCU_SPEED}
        )

set_target_properties(example_exec-elf
        PROPERTIES
        NO_SYSTEM_FROM_IMPORTED ON
        CXX_EXTENSIONS ON
        LINKER_LANGUAGE C
        LINK_FLAGS "-w -flto -Wl,--gc-sections -mmcu=${AVR_MCU}"
        OUTPUT_NAME "example_exec.elf"
        )

#avr-g++ -w -Os -g -flto -Wl,--gc-sections -mmcu=atmega328p  main.cpp.obj  -o testlibarduino.elf -lm libarduino_core.a

find_package(PekoeVMArduino 1.0 REQUIRED)
target_link_libraries(example_exec-elf PekoeVM::PekoeVMArduino)


# HEX file
add_custom_command(
        OUTPUT example_exec.hex
        COMMAND
        ${CMAKE_AVROBJCOPY_PROGRAM} -O ihex -R .eeprom example_exec.elf example_exec.hex
        COMMAND
        ${CMAKE_AVRSIZE_PROGRAM} -C;--mcu=${AVR_MCU} example_exec.elf
        #${CMAKE_AVRSIZE_PROGRAM} -A example_exec.elf
        #${CMAKE_AVRSIZE_PROGRAM} -B example_exec.elf
        DEPENDS example_exec-elf
)

#Generating HEX image
#avr-objcopy -O ihex -R .eeprom testlibarduino.elf testlibarduino.hex

# eeprom
add_custom_command(
        OUTPUT example_exec.eep
        COMMAND
        ${CMAKE_AVROBJCOPY_PROGRAM} -O ihex -j .eeprom --set-section-flags=.eeprom=alloc,load
        --no-change-warnings --change-section-lma .eeprom=0
        example_exec.elf example_exec.eep
        DEPENDS example_exec-elf
)

#Generating EEP image
#avr-objcopy -O ihex -j .eeprom --set-section-flags=.eeprom=alloc,load --no-change-warnings --change-section-lma .eeprom=0 testlibarduino.elf testlibarduino.eep


# ISTO É UM TARGET QUE VAI INVOCAR COMANDOS MAS NÃO GERA NADA POR SI MESMO
# main executable target
add_custom_target(
        example_exec-main
        ALL
        DEPENDS example_exec.eep example_exec.hex
)

# clean
#get_directory_property(clean_files ADDITIONAL_MAKE_CLEAN_FILES)
#set_directory_properties(
#        PROPERTIES
#        ADDITIONAL_MAKE_CLEAN_FILES "example_exec.map"
#)

# upload - with avrdude
add_custom_target(
        example_exec-upload
        ${CMAKE_AVRDUDE_PROGRAM} -v -p ${AVR_MCU} -c ${AVR_PROGRAMMER} ${AVR_UPLOADTOOL_OPTIONS} # TODO: what options are these?
        -U flash:w:example_exec.hex
        -P ${AVR_UPLOADTOOL_PORT}
        DEPENDS example_exec.hex
        COMMENT "Uploading example_exec.hex to ${AVR_MCU} using ${AVR_PROGRAMMER}"
)

#avrdude -Cavrdude.conf -v -patmega328p -carduino -P/dev/cu.usbmodem14101 -b115200 -D -Uflash:w:/var/folders/by/ch1sh3293bj3fthdqlyx0f9m0000gn/T/arduino_build_927443/sketch_oct04a.ino.hex:i


# upload eeprom only - with avrdude
# see also bug http://savannah.nongnu.org/bugs/?40142
add_custom_target(
        example_exec-upload_eeprom
        ${CMAKE_AVRDUDE_PROGRAM} -p ${AVR_MCU} -c ${AVR_PROGRAMMER} ${AVR_UPLOADTOOL_OPTIONS}
        -U eeprom:w:example_exec.eep
        -P ${AVR_UPLOADTOOL_PORT}
        DEPENDS example_exec.eep
        COMMENT "Uploading example_exec.eep to ${AVR_MCU} using ${AVR_PROGRAMMER}"
)

# get status
add_custom_target(
        get_status
        ${CMAKE_AVRDUDE_PROGRAM} -p ${AVR_MCU} -c ${AVR_PROGRAMMER} -P ${AVR_UPLOADTOOL_PORT} -n -v
        COMMENT "Get status from ${AVR_MCU}"
)

# get fuses
add_custom_target(
        get_fuses
        ${CMAKE_AVRDUDE_PROGRAM} -p ${AVR_MCU} -c ${AVR_PROGRAMMER} -P ${AVR_UPLOADTOOL_PORT} -n
        -U lfuse:r:-:b
        -U hfuse:r:-:b
        -U efuse:r:-:b
        COMMENT "Get fuses from ${AVR_MCU}"
)

# set fuses
add_custom_target(
        example_exec-set_fuses
        ${CMAKE_AVRDUDE_PROGRAM} -p ${AVR_MCU} -c ${AVR_PROGRAMMER} -P ${AVR_UPLOADTOOL_PORT}
        -U lfuse:w:${AVR_L_FUSE}:m
        -U hfuse:w:${AVR_H_FUSE}:m
        -U hfuse:w:${AVR_E_FUSE}:m
        COMMENT "Setup: High Fuse: ${AVR_H_FUSE} Low Fuse: ${AVR_L_FUSE} Extended Fuse: ${AVR_E_FUSE}"
)

# get oscillator calibration
add_custom_target(
        example_exec-get_calibration
        ${CMAKE_AVRDUDE_PROGRAM} -p ${AVR_MCU} -c ${AVR_PROGRAMMER} -P ${AVR_UPLOADTOOL_PORT}
        -U calibration:r:${AVR_MCU}_calib.tmp:r
        COMMENT "Write calibration status of internal oscillator to ${AVR_MCU}_calib.tmp."
)

# set oscillator calibration
add_custom_target(
        example_exec-set_calibration
        ${CMAKE_AVRDUDE_PROGRAM} -p ${AVR_MCU} -c ${AVR_PROGRAMMER} -P ${AVR_UPLOADTOOL_PORT}
        -U calibration:w:${AVR_MCU}_calib.hex
        COMMENT "Program calibration status of internal oscillator from ${AVR_MCU}_calib.hex."
)

# disassemble
add_custom_target(
        example_exec-disassemble
        ${CMAKE_AVROBJDUMP_PROGRAM} -h -S example_exec.elf > example_exec.lst
        DEPENDS example_exec-elf
)
