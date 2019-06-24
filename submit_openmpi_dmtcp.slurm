#!/bin/bash
#SBATCH -J example_mpi
#SBATCH -A SUPPORT-CPU
#SBATCH --output=example_mpi.out

#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --cpus-per-task=1
#SBATCH --time=00:03:00

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

# configure openmpi environment to use tcp
export OMPI_MCA_mtl=^psm
export OMPI_MCA_btl=self,tcp

RESTARTSCRIPT="dmtcp_restart_script.sh"
export DMTCP_QUIET=2

h=`hostname`
echo $h

runcmd="./example_mpi"
tint=30

export DMTCP_DL_PLUGIN=0

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
    #CMD="dmtcp_restart -p "$cport" -i "$tint" ckpt*.dmtcp"
    CMD="./dmtcp_restart_script.sh -h $DMTCP_COORD_HOST -p $DMTCP_COORD_PORT"
    echo $CMD
    eval $CMD
else
    echo "Start the application"
    mpirun dmtcp_launch --no-gzip ./example_mpi
    #CMD="mpirun -np 4 ./run_dmtcp.sh"
    #echo $CMD
    #eval $CMD
fi

echo "Stopped program execution"
date
sleep 2
