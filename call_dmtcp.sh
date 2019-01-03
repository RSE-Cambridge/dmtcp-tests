#!/bin/bash
RESTARTSCRIPT="dmtcp_restart_script.sh"
export DMTCP_QUIET=2

runcmd="../example"
tint=5

runcmd=$1
tint=$2

if [ -f "$RESTARTSCRIPT" ]
then
    echo "Start with checkpoint executable"

    eval "dmtcp_coordinator --exit-after-ckpt --exit-on-last --port-file cport.txt -p 0 &"
    sleep 1
    cport=$(<cport.txt)
    echo "$cport"
    CMD="dmtcp_restart -i "$tint" -p "$cport" ./ckpt_*.dmtcp" 
    echo $CMD
    eval $CMD
else
    echo "Start new executable"
    
    eval "dmtcp_coordinator --exit-after-ckpt --exit-on-last --port-file cport.txt -p 0 &"
    sleep 1
    cport=$(<cport.txt)
    echo "$cport"
    CMD="dmtcp_launch -i "$tint" -p "$cport" "$runcmd
    echo $CMD
    eval $CMD
fi
