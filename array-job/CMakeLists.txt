cmake_minimum_required(VERSION 3.13)

project(dmtcp_array)

add_executable(example_array example.cpp)
target_compile_features(example_array PRIVATE cxx_std_14)

add_custom_command(
        TARGET example_array POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy
        ${CMAKE_CURRENT_SOURCE_DIR}/submit_array.slurm
        ${CMAKE_CURRENT_BINARY_DIR}/submit_array.slurm)