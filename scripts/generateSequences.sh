#!/bin/sh
#
# js shell need to be on the path.

RAW_DATA=rawData
OBS_DIR=observations

for f in ${RAW_DATA}/*.asm
do
  base=`basename -s .asm $f`
  output=${OBS_DIR}/${base}.seq
  echo "Writing sequence for $f to $output"
  `js x86.js/createObservation.js < $f > $output`
done

