#!/bin/bash
#SBATCH -J dmtcp_array
#SBATCH -A SUPPORT-CPU
#SBATCH --output=dmtcp_array_%A_%a.out
#SBATCH --error=dmtcp_array_%A_%a.err
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=00:01:00
#SBATCH --array=0-31
#SBATCH -p skylake

. /etc/profile.d/modules.sh
module purge
module load rhel7/default-peta4
module load dmtcp/2.6.0-intel-17.0.4
ulimit -s 8192

#! The variable $SLURM_ARRAY_TASK_ID contains the array index for each job.
#! In this example, each job will be passed its index, so each output file will contain a different value
echo "This is job" $SLURM_ARRAY_TASK_ID

#! Command line that we want to run:
jobDir=Job_$SLURM_ARRAY_TASK_ID
mkdir $jobDir
cd $jobDir

RESTARTSCRIPT="dmtcp_restart_script.sh"
export DMTCP_QUIET=2

runcmd="../example_array 5"
tint=30

echo "Start coordinator"
date
eval "dmtcp_coordinator --daemon --coord-logfile dmtcp_log.txt --exit-after-ckpt --exit-on-last -i "$tint" --port-file cport.txt -p 0"
sleep 2
cport=$(<cport.txt)
echo "$cport"
h=`hostname`
echo $h

if [ -f "$RESTARTSCRIPT" ]
then
    echo "Resume the application"
    CMD="dmtcp_restart -p "$cport" -i "$tint" ckpt*.dmtcp"
    echo $CMD
    eval $CMD
else
    echo "Start the application"
    CMD="dmtcp_launch --rm --infiniband --no-gzip -h localhost -p "$cport" "$runcmd
    echo $CMD
    eval $CMD
fi

echo "Stopped program execution"
date
