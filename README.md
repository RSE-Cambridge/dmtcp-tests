# dmtcp-tests

Several simple examples that demonstrate how to use DMTCP to checkpoint serial and parallel jobs. 

To build the project on CSD3 (Cambridge Cluster) use the following
    
    module load cmake/latest openmpi/3.1.4-gcc-7.2.0
    
    mkdir build
    cd build
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER=mpicc -DCMAKE_CXX_COMPILER=mpic++ ..
    make

There are two example submission slurm scripts. One uses a job array to submit multiple serial jobs and the another uses the srun command. Both scripts run the call_dmtcp script which takes two arguments. The first is the executable with its arguments and the second is the number of seconds after the start of the executable the dmtcp with generate a checkpoint. After the generation of the checkpoint the executable will exit.

To restart the jobs just resubmit the slurm script.
