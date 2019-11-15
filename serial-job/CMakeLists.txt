cmake_minimum_required(VERSION 3.13)

project(dmtcp_serial)

add_executable(example_serial example.cpp)
target_compile_features(example_serial PRIVATE cxx_std_14)

add_custom_command(
        TARGET example_serial POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy
        ${CMAKE_CURRENT_SOURCE_DIR}/submit_serial.slurm
        ${CMAKE_CURRENT_BINARY_DIR}/submit_serial.slurm)