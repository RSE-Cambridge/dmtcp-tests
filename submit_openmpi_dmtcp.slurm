#!/bin/bash
#SBATCH -J example_mpi
#SBATCH -A SUPPORT-CPU
#SBATCH --output=example_mpi.out

#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --cpus-per-task=1
#SBATCH --time=00:03:00
#SBATCH --mem=200mb

#! This is the partition name. This will request for a node with 6GB RAM for each task
#SBATCH -p skylake

#! mail alert at start, end and abortion of execution
#! emails will default to going to your email address
#! you can specify a different email address manually if needed.
##SBATCH --mail-type=ALL

#! Don't put any #SBATCH directives below this line

. /etc/profile.d/modules.sh
module purge
module load rhel7/default-peta4
module load use.own
module load dmtcp/2.6.0-intel-17.0.4
ulimit -s 8192
module load gcc-7.2.0-gcc-4.8.5-pqn7o2k
module load openmpi-4.0.1-gcc-7.2.0-myumaue

#! Command line that we want to run:

runcmd="srun ./example"
tint=30

echo "Start coordinator"
date
eval "dmtcp_coordinator --daemon --coord-logfile dmtcp_log.txt --exit-after-ckpt --exit-on-last -i "$tint" --port-file cport.txt -p 0"
sleep 2
cport=$(<cport.txt)
echo "$cport"

if [ -f "$RESTARTSCRIPT" ]
then
    echo "Resume the application"
    CMD="dmtcp_restart -p "$cport" -i "$tint" ckpt*.dmtcp"
    echo $CMD
    eval $CMD
else
    echo "Start the application"
    CMD="dmtcp_launch --rm --no-gzip -h localhost -p "$cport" "$runcmd
    echo $CMD
    eval $CMD
fi

echo "Stopped program execution"
date
sleep 2