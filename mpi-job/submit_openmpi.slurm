#!/bin/bash
#SBATCH -J dmtcp_mpi
#SBATCH -A SUPPORT_CPU
#SBATCH --output=dmtcp_mpi_%A.out
#SBATCH --error=dmtcp_mpi_%A.err
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --time=00:01:00
#SBATCH -p skylake

. /etc/profile.d/modules.sh
module purge
module load rhel7/default-peta4
module load dmtcp/2.6.0-intel-17.0.4
ulimit -s 8192
module load openmpi/3.1.4-gcc-7.2.0

RESTARTSCRIPT="dmtcp_restart_script.sh"
export DMTCP_QUIET=2

runcmd=./example_mpi
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

if [ -f "$RESTARTSCRIPT" ]
then
    echo "Resume the application"
    CMD="./dmtcp_restart_script.sh -h"$DMTCP_COORD_HOST"-p"$DMTCP_COORD_PORT
    echo $CMD
    eval $CMD
else
    echo "Start the application"
    CMD="mpirun -env I_MPI_FABRICS tcp -ppn 32 -np"${SLURM_NTASKS}"dmtcp_launch --ckpt-open-files --infiniband --no-gzip --rm $runcmd"
    echo $CMD
    eval $CMD
fi

echo "Stopped program execution"
date
sleep 2
dmtcp_command -h $DMTCP_COORD_HOST -p $DMTCP_COORD_PORT --quit