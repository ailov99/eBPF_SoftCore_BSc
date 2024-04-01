cmake_minimum_required(VERSION 3.29)

project(
  ebpf_emulator
  VERSION 0.1
  DESCRIPTION "ebpf_emulator"
  LANGUAGES CXX
)

# Only do these if this is the main project, and not if it is included through add_subdirectory
if(CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME)

  # Ensure -std=c++xx instead of -std=g++xx
  set(CMAKE_CXX_EXTENSIONS OFF)

  # Nicely support folders in IDEs
  set_property(GLOBAL PROPERTY USE_FOLDERS ON)

endif()

# C++11
set(CMAKE_CXX_STANDARD 11)

set(HEADER_LIST 
  "Assembler.h"
  "Opcodes.h"
  "Register.h"
  "VM.h"
)
set(SRC_LIST 
  "Assembler.cpp"
  "Register.cpp"
  "VM.cpp"
  "main.cpp" 
)

add_executable(main ${SRC_LIST} ${HEADER_LIST})

# Have at least c++11
target_compile_features(main PRIVATE cxx_std_11)