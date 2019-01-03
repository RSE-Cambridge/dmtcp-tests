#!/bin/bash
RESTARTSCRIPT="dmtcp_restart_script.sh"

if [ -f "$RESTARTSCRIPT" ]
then
    echo "Start with checkpoint executable"

    eval "dmtcp_coordinator -q --exit-after-ckpt --exit-on-last --port-file cport.txt -p 0 &"
    sleep 1
    cport=$(<cport.txt)
    echo "$cport"
    CMD="dmtcp_restart -q -i 5 -p "$cport" ./ckpt_*.dmtcp" 
    echo $CMD
    eval $CMD
else
    echo "Start new executable"
    
    eval "dmtcp_coordinator -q --exit-after-ckpt --exit-on-last --port-file cport.txt -p 0 &"
    sleep 1
    cport=$(<cport.txt)
    echo "$cport"
    CMD="dmtcp_launch -q -i 5 -p "$cport" ../example"
    echo $CMD
    eval $CMD
fi
