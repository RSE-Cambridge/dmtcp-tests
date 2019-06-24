cmake_minimum_required(VERSION 3.13.4)
project(dmtcp_example)

add_executable(example example.cpp)
target_compile_features(example PRIVATE cxx_std_17)
add_executable(example_mpi example_mpi.cpp)
target_compile_features(example_mpi PRIVATE cxx_std_17)