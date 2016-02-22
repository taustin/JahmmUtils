#!/bin/sh

TYPE=$1
NUM_STATES=$2
TYPE_LOWER=`echo $TYPE | tr "[:upper:]" "[:lower:]"`

GCC_HMM=models/GCC-smoothed-${NUM_STATES}.hmm
CLANG_HMM=models/CLANG-smoothed-${NUM_STATES}.hmm
MINGW_HMM=models/MINGW-smoothed-${NUM_STATES}.hmm
TURBOC_HMM=models/TURBOC-smoothed-${NUM_STATES}.hmm
TASM_HMM=models/TASM-smoothed-${NUM_STATES}.hmm

for SLICE in 1 2 3 4 5
do
  VIR_HMM=models/${TYPE_LOWER}/smoothed-st${NUM_STATES}-${SLICE}.hmm
  TESTDIR=./observations/${TYPE_LOWER}/${SLICE}/
  echo "Testing ${VIR_HMM}"
  for i in `ls $TESTDIR/*.seq`
  do
    java -jar dist/Estimater.jar $i $VIR_HMM $GCC_HMM $CLANG_HMM $MINGW_HMM $TURBOC_HMM $TASM_HMM
  done
  echo "****TESTING CONTROL DATA"
  for CTRL_TYPE in gcc clang mingw turboc tasm
  do
    echo "Testing ${CTRL_TYPE}"
    CTRLDIR=./observations/${CTRL_TYPE}Test/
    for i in `ls $CTRLDIR/*.seq`
    do
      java -jar dist/Estimater.jar $i $VIR_HMM $GCC_HMM $CLANG_HMM $MINGW_HMM $TURBOC_HMM $TASM_HMM
    done
  done
  echo
done

