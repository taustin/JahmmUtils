#!/bin/sh

TYPE=$1
NUM=$2

echo "Regenerating sequences for testing ${TYPE} (batch ${NUM})"
for i in `ls rawData/${TYPE}Slices/${NUM}/*.asm`
do
  js -f x86.js/createObservation.js < $i > $i.seq
done
mv rawData/${TYPE}Slices/${NUM}/*.seq observations/${TYPE}/${NUM}/


