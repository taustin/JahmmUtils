#!/bin/sh

#TESTDIR=$1
#shift
STATES=$1
SRC=$2
THRESH=$3

NUM=1
echo "Testing group $NUM"
HMM=models/$SRC/smoothed-st$STATES-$NUM.hmm

# Testing virus code
TESTDIR=observations/$SRC/$NUM
for i in `ls $TESTDIR/*.seq`
do
  java -jar dist/Estimater.jar $i $HMM $THRESH
done

echo
echo "Testing group $NUM control"
for CTRL in gcc clang mingw turboc tasm
do
  echo $CTRL
  TESTDIR=observations/$CTRL/$NUM
  for i in `ls $TESTDIR/*.seq`
  do
    java -jar dist/Estimater.jar $i $HMM $THRESH
  done
done

echo
echo

#for i in `ls $TESTDIR/*.seq`
#do
#  java -jar dist/Estimater.jar $i $1 $2
#done

