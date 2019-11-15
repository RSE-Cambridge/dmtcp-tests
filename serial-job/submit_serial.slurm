#!/bin/bash
#SBATCH -J dmtcp_serial
#SBATCH -A SUPPORT-CPU
#SBATCH --output=dmtcp_serial_%A.out
#SBATCH --error=dmtcp_serial_%A.err
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=00:01:00
#SBATCH -p skylake

. /etc/profile.d/modules.sh
module purge
module load rhel7/default-peta4
module load dmtcp/2.6.0-intel-17.0.4
ulimit -s 8192

RESTARTSCRIPT="dmtcp_restart_script.sh"
export DMTCP_QUIET=2

runcmd="./example_serial 5"
tint=5

echo "Start coordinator"
date
eval "dmtcp_coordinator --daemon --coord-logfile dmtcp_log.txt --exit-after-ckpt --exit-on-last -i "$tint" --port-file cport.txt -p 0"
sleep 2
cport=$(<cport.txt)
echo "$cport"
h=`hostname`
echo $h

export DMTCP_COORD_HOST=`hostname`
export DMTCP_COORD_PORT=$cport

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
sleep 2
dmtcp_command -h $DMTCP_COORD_HOST -p $DMTCP_COORD_PORT --quit