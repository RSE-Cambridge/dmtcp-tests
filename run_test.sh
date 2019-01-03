#!/bin/bash

rm ckpt*
rm dmtcp*

counter=1
while [ $counter -le 5 ]
do
  ../run_long.sh
  ((counter++))
done
