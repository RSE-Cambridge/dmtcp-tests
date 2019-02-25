#!/bin/bash
RESTARTSCRIPT="dmtcp_restart_script.sh"
export DMTCP_QUIET=2

runcmd=$1
tint=$2

echo "Start coordinator"
date
eval "dmtcp_coordinator --exit-after-ckpt -i "$tint" --port-file cport.txt -p 0 &"
sleep 5
cport=$(<cport.txt)
echo "$cport"

if [ -f "$RESTARTSCRIPT" ]
then
    echo "Resume executable"
    CMD="dmtcp_restart --ckptdir ckpoints -p "$cport" ckpoints/ckpt_*.dmtcp"
    echo $CMD
    eval $CMD
else
    echo "Start new executable"
    CMD="dmtcp_launch --ckptdir ckpoints --ckpt-open-files -p "$cport" "$runcmd
    echo $CMD
    eval $CMD
fi

echo "Stopped program execution"
date
sleep 60
CMD="dmtcp_command --quit --port "$cport""
echo $CMD
eval $CMD
