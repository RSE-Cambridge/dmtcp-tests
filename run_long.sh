#!/bin/bash
RESTARTSCRIPT="dmtcp_restart_script.sh"
#RESTARTSCRIPT="ckpt*"

if [ -f "$RESTARTSCRIPT" ]
then
    echo "Start with checkpoint executable"
    #eval "../kill_long.sh &"

    if [[ "$1" -eq "1" ]];
    then
      eval "dmtcp_coordinator -q --exit-after-ckpt --exit-on-last --port-file cport.txt -p 0 &"
      sleep 1
      cport=$(<cport.txt)
      echo "$cport"
      CMD="dmtcp_restart -q -i 5 -p "$cport" ./ckpt_*.dmtcp" 
      echo $CMD
      eval $CMD
    else
      eval "/home/ea461/dmtcp/dmtcp-2.3.1/bin/dmtcp_coordinator -q --exit-after-ckpt --exit-on-last --port-file cport.txt -p 0 &"
      sleep 1
      cport=$(<cport.txt)
      echo "$cport"
      CMD="/home/ea461/dmtcp/dmtcp-2.3.1/bin/dmtcp_restart -q -i 5 -p "$cport" ./ckpt_*.dmtcp" 
      echo $CMD
      eval $CMD
    fi
else
    echo "Start new executable"
    #eval "../kill_long.sh &"
    if [[ "$1" -eq "1" ]];
    then
      eval "dmtcp_coordinator -q  --exit-after-ckpt --exit-on-last --port-file cport.txt -p 0 &"
      sleep 1
      cport=$(<cport.txt)
      echo "$cport"
      CMD="dmtcp_launch -q -i 5 -p "$cport" ../example"
      echo $CMD
      eval $CMD
    else
      eval "/home/ea461/dmtcp/dmtcp-2.3.1/bin/dmtcp_coordinator -q --exit-after-ckpt --exit-on-last --port-file cport.txt -p 0 &"
      sleep 1
      cport=$(<cport.txt)
      echo "$cport"
      CMD="/home/ea461/dmtcp/dmtcp-2.3.1/bin/dmtcp_launch -q -i 5 -p "$cport" ../example"
      echo $CMD
      eval $CMD
    fi
fi
