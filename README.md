# dmtcp-tests

A simple example that demonstrates how to use DMTCP to checkpoint serial jobs. 

Compile example.cpp using the following

    g++ --std=c++11 example.cpp -o example

There are two example submission slurm scripts. One uses a job array to submit multiple serial jobs and the another uses the srun command. Both scripts run the call_dmtcp script which takes two arguments. The first is the executable with its arguments and the second is the number of seconds after the start of the executable the dmtcp with generate a checkpoint. After the generation of the checkpoint the executable will exit.

To restart the jobs just resubmit the slurm script.