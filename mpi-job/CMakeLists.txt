cmake_minimum_required(VERSION 3.13)

project(dmtcp_mpi)

add_executable(example_mpi example_mpi.cpp)
target_compile_features(example_mpi PRIVATE cxx_std_14)

add_custom_command(
        TARGET example_mpi POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy
        ${CMAKE_CURRENT_SOURCE_DIR}/submit_openmpi.slurm
        ${CMAKE_CURRENT_BINARY_DIR}/submit_openmpi.slurm)

add_custom_command(
        TARGET example_mpi POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy
        ${CMAKE_CURRENT_SOURCE_DIR}/submit_intel_mpi.slurm
        ${CMAKE_CURRENT_BINARY_DIR}/submit_intel_mpi.slurm)