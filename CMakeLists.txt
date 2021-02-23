cmake_minimum_required (VERSION 3.9)
cmake_policy(SET CMP0054 NEW)
cmake_policy(SET CMP0072 NEW)
project (galax)

enable_language(CUDA)
set(CMAKE_CUDA_ARCHITECTURES 52 61 75)

# Enable C++11
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Specify bin path
set (EXECUTABLE_OUTPUT_PATH bin/)

# Generate the source files lists
set(SRC_FILES_MAIN    ${CMAKE_CURRENT_SOURCE_DIR}/src/Model/Model.cpp
                      ${CMAKE_CURRENT_SOURCE_DIR}/src/Model/Model_GPU/kernel.cu
                      ${CMAKE_CURRENT_SOURCE_DIR}/src/Model/Model_GPU/Model_GPU.cpp
                      ${CMAKE_CURRENT_SOURCE_DIR}/src/main.cpp)

# add library & executable
add_executable(galax ${SRC_FILES_MAIN})

# Find Cuda
find_package(CUDA REQUIRED QUIET)
if(CUDA_FOUND)
    message(STATUS "Galax - Library found: CUDA")
    include_directories(PUBLIC "${CUDA_INCLUDE_DIRS}")
    target_link_libraries(galax  PUBLIC ${CUDA_LIBRARIES}   )
endif(CUDA_FOUND)
