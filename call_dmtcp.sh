#!/bin/bash
RESTARTSCRIPT="dmtcp_restart_script.sh"
export DMTCP_QUIET=2

runcmd=$1
tint=$2

if [ -f "$RESTARTSCRIPT" ]
then
    echo "Start with checkpoint executable"

    eval "dmtcp_coordinator --exit-after-ckpt --exit-on-last --port-file cport.txt -p 0 &"
    sleep 1
    cport=$(<cport.txt)
    echo "$cport"
    CMD="dmtcp_restart --ckptdir ckpoints -i "$tint" -p "$cport" ckpoints/ckpt_*.dmtcp"
    echo $CMD
    eval $CMD
else
    echo "Start new executable"

    eval "dmtcp_coordinator --exit-after-ckpt --exit-on-last --port-file cport.txt -p 0 &"
    sleep 1
    cport=$(<cport.txt)
    echo "$cport"
    CMD="dmtcp_launch --no-gzip --ckptdir ckpoints --ckpt-open-files -i "$tint" -p "$cport" "$runcmd
    echo $CMD
    eval $CMD
fi

sleep 60
