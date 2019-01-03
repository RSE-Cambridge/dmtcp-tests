#!/bin/bash
#RESTARTSCRIPT="dmtcp_restart_script.sh"

echo "Checkpoint script started."
sleep 10
#eval "dmtcp_command --quit"
cport=$(<cport.txt)
echo "$cport"
eval "/home/ea461/dmtcp/dmtcp-2.3.1/bin/dmtcp_command -p $cport --quit"
exit 0
