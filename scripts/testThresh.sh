#!/bin/sh

TYPE=$1
NUM_STATES=$2
TYPE_LOWER=`echo $TYPE | tr "[:upper:]" "[:lower:]"`
THRESH=$3

for SLICE in 1 2 3 4 5
do
  VIR_HMM=models/${TYPE_LOWER}/smoothed-st${NUM_STATES}-${SLICE}.hmm
  TESTDIR=./observations/${TYPE_LOWER}/${SLICE}/
  echo "Testing ${VIR_HMM}"
  for i in `ls $TESTDIR/*.seq`
  do
    java -jar dist/Estimater.jar -t $i $VIR_HMM $THRESH
  done
  echo "****TESTING CONTROL DATA"
  for CTRL_TYPE in gcc clang mingw turboc tasm
  do
    echo "Testing ${CTRL_TYPE}"
    CTRLDIR=./observations/${CTRL_TYPE}Test/
    for i in `ls $CTRLDIR/*.seq`
    do
      java -jar dist/Estimater.jar -t $i $VIR_HMM $THRESH
    done
  done
  echo
done

