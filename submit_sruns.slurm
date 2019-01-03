#!/bin/bash
#! This line is a comment
#! Make sure you only have comments and #SBATCH directives between here and the end of the #SBATCH directives, or things will break
#! Name of the job:
#SBATCH -J test_dmtcp
#! Account name for Gilligan group, use SL2 for paying queue:
#SBATCH -A SUPPORT-CPU
#! Output filename:
#! %A means slurm job ID and %a means array index
#SBATCH --output=test_dmtcp.out 
#! Errors filename:
#SBATCH --error=test_dmtcp.err 

#! Number of nodes to be allocated for the job (for single core jobs always leave this at 1)
#SBATCH --nodes=1 
#! Number of tasks. By default SLURM assumes 1 task per node and 1 CPU per task. (for single core jobs always leave this at 1)
#SBATCH --ntasks=2
#! How many many cores will be allocated per task? (for single core jobs always leave this at 1)
#SBATCH --cpus-per-task=1 
#! Estimated runtime: hh:mm:ss (job is force-stopped after if exceeded):
#SBATCH --time=00:03:00
#! Estimated maximum memory needed (job is force-stopped if exceeded):
#! RAM is allocated in ~5990mb blocks, you are charged per block used,
#! and unused fractions of blocks will not be usable by others.
#SBATCH --mem=100mb

#! This is the partition name. This will request for a node with 6GB RAM for each task
#SBATCH -p skylake

#! mail alert at start, end and abortion of execution
#! emails will default to going to your email address
#! you can specify a different email address manually if needed.
##SBATCH --mail-type=ALL

#! Don't put any #SBATCH directives below this line

#! Modify the environment seen by the application. For this example we need the default modules.
. /etc/profile.d/modules.sh                # This line enables the module command
module purge                               # Removes all modules still loaded
module load rhel7/default-peta4            # REQUIRED - loads the basic environment
module load use.own                        # This line loads the own module list
module load dmtcp/2.3.1

#! Command line that we want to run:
mkdir job_0
cd job_0
srun --exclusive -n 1 ../call_dmtcp.sh "../example" 5 &
cd ..

mkdir job_1
cd job_1
srun --exclusive -n 1 ../call_dmtcp.sh "../example" 5 &

wait