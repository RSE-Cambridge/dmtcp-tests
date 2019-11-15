cmake_minimum_required(VERSION 3.13)

project(dmtcp_examples
        VERSION 1.0.0
        DESCRIPTION "DMCTP Slurm examples.")

set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(CMAKE_CXX_STANDARD 17)

add_subdirectory(serial-job)
add_subdirectory(array-job)
add_subdirectory(mpi-job)