set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_VERSION 1)
set(CMAKE_TRY_COMPILE_TARGET_TYPE "STATIC_LIBRARY")
cmake_minimum_required(VERSION 3.20)

set(CMAKE_EXPORT_COMPILE_COMMANDS 1)

set(SDK $ENV{WCH_SDK_PATH})

set(TOOLCHAIN $ENV{WCH_TOOLCHAIN}-)

set(CMAKE_C_COMPILER ${TOOLCHAIN}gcc)
set(CMAKE_CXX_COMPILER ${TOOLCHAIN}g++)
set(CMAKE_ASM_COMPILER ${TOOLCHAIN}gcc)
set(CMAKE_AR ${TOOLCHAIN}ar)
set(CMAKE_OBJCOPY ${TOOLCHAIN}objcopy)
set(CMAKE_OBJDUMP ${TOOLCHAIN}objdump)
set(SIZE ${TOOLCHAIN}size)

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

set(TOP_PROJECT_NAME "WCH")

project(${TOP_PROJECT_NAME} C CXX ASM)
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_C_STANDARD 99)

if($ENV{WCH_TOOLCHAIN} STREQUAL "riscv-none-embed")
  add_compile_options(-march=rv32imac)
else()
  add_compile_options(-march=rv32imac_zicsr)
endif()

add_compile_options(
  -mabi=ilp32 
  -mcmodel=medany
  -msmall-data-limit=8 
  -mno-save-restore
  -fmessage-length=0 
  -fsigned-char 
  -ffunction-sections
  -fdata-sections 
  -fno-common
)

if(CMAKE_BUILD_TYPE AND (CMAKE_BUILD_TYPE STREQUAL "Debug"))
  set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -Wall -O0")
  set(CMAKE_CXX_FLAGS_DEBUG "-DDEBUG -O0 -g")
  set(CMAKE_ASM_FLAGS_DEBUG "-DDEBUG -O0 -g")
  message("Debug mode:${CMAKE_C_FLAGS_DEBUG}")
elseif(CMAKE_BUILD_TYPE AND (CMAKE_BUILD_TYPE STREQUAL "Release"))
  set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -Wall -O2")
  set(CMAKE_CXX_FLAGS_RELEASE "-DNDEBUG -Os") # -flto
  set(CMAKE_ASM_FLAGS_RELEASE "-DNDEBUG -Os")
  message("Release mode:${CMAKE_C_FLAGS_RELEASE}")
else()
  message("else:${CMAKE_BUILD_TYPE}")
  message("else:${CMAKE_C_FLAGS_RELEASE}")
endif()

include_directories(
  ${SDK}/BLE/LIB
  ${SDK}/SRC/StdPeriphDriver/inc
  ${SDK}/USB/Host/USB_LIB
  ${SDK}/SRC/RVMSIS
  ${SDK}/BLE/HAL/include
  ${SDK}/BLE/MESH/MESH_LIB
  APP/inc
)

add_definitions(-DDEBUG=1)

file(
  GLOB_RECURSE
  SOURCES
  ${SDK}/SRC/Startup/*.S
  ${SDK}/USB/Host/USB_LIB/*.c
  ${SDK}/SRC/RVMSIS/*.c
  ${SDK}/SRC/StdPeriphDriver/*.c
  ${SDK}/BLE/HAL/*.c
  APP/*.c
)

set(LINKER_SCRIPT ${SDK}/SRC/Ld/Link.ld)
add_link_options(
  -march=rv32imac
  -mabi=ilp32
  -nostartfiles
  -Xlinker
  --gc-sections
  -Wl,--print-memory-usage
  -Wl,-Map,${PROJECT_NAME}.map
  --specs=nano.specs
  --specs=nosys.specs
  -nostdlib)
add_link_options(-T ${LINKER_SCRIPT})

add_executable(${PROJECT_NAME}.elf ${SOURCES} ${LINKER_SCRIPT})

target_link_libraries(
  ${PROJECT_NAME}.elf
  ${SDK}/SRC/StdPeriphDriver/libISP583.a
  ${SDK}/BLE/LIB/LIBCH58xBLE.a
  ${SDK}/USB/Host/USB_LIB/libRV3UFI.a
  ${SDK}/BLE/MESH/MESH_LIB/LIBCH58xMESHROM.a
  ${SDK}/BLE/MESH/MESH_LIB/LIBMESH.a
)

if(CMAKE_BUILD_TYPE AND (CMAKE_BUILD_TYPE STREQUAL "Debug"))
  set(EXECUTABLE_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/build/debug) # ELF
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/build/debug)
  set(PROJECT_BINARY_DIR ${PROJECT_SOURCE_DIR}/build/debug) # Hex/Bin
elseif(CMAKE_BUILD_TYPE AND (CMAKE_BUILD_TYPE STREQUAL "Release"))
  set(EXECUTABLE_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/build/release) # ELF
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/build/release)
  set(PROJECT_BINARY_DIR ${PROJECT_SOURCE_DIR}/build/release) # Hex/Bin
endif()

set(HEX_FILE ${PROJECT_BINARY_DIR}/${PROJECT_NAME}.hex)
set(BIN_FILE ${PROJECT_BINARY_DIR}/${PROJECT_NAME}.bin)
add_custom_command(
  TARGET ${PROJECT_NAME}.elf
  POST_BUILD
  COMMAND ${CMAKE_OBJCOPY} -Oihex $<TARGET_FILE:${PROJECT_NAME}.elf> ${HEX_FILE}
  COMMAND ${CMAKE_OBJCOPY} -Obinary $<TARGET_FILE:${PROJECT_NAME}.elf>
          ${BIN_FILE})