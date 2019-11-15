#!/bin/bash
#SBATCH -J example_mpi
#SBATCH -A SUPPORT-CPU
#SBATCH --output=example_mpi.out

#SBATCH --nodes=3
#SBATCH --ntasks=96
#SBATCH --cpus-per-task=1
#SBATCH --time=00:05:00

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

RESTARTSCRIPT="dmtcp_restart_script.sh"
export DMTCP_QUIET=0

runcmd="./example_mpi"
tint=30

echo "Start coordinator"
date
eval "dmtcp_coordinator --daemon --coord-logfile dmtcp_log.txt --exit-after-ckpt --exit-on-last -i "$tint" --port-file cport.txt -p 0"
sleep 2
cport=$(<cport.txt)
echo $cport
h=`hostname`
echo $h

export DMTCP_COORD_HOST=$h
export DMTCP_COORD_PORT=$cport

HOSTFILE=hostfile
echo "SLURM_JOB_NODELIST" | scontrol show hostname > $HOSTFILE

if [ -f "$RESTARTSCRIPT" ] 
then
    echo "Resume the application"
    ./dmtcp_restart_script.sh -h $DMTCP_COORD_HOST -p $DMTCP_COORD_PORT
else
    echo "Start the application"
    mpirun -env I_MPI_FABRICS tcp -ppn 32 -np 96 dmtcp_launch --no-gzip --rm $runcmd
fi

echo "Stopped program execution"
date
sleep 2
