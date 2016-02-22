#!/bin/sh

#TESTDIR=$1
#shift
STATES=$1
SRC=$2
THRESH=$3

SRC_UPPER=`echo $SRC | tr "[:lower:]" "[:upper:]"`

#NUM=1
#echo "Testing group $NUM"
#HMM=models/$SRC/smoothed-st$STATES-$NUM.hmm
HMM=models/$SRC_UPPER-smoothed-$STATES.hmm

# Testing virus code
TESTDIR=observations/${SRC}Test
for i in `ls $TESTDIR/*.seq`
do
  java -jar dist/Estimater.jar $i $HMM $THRESH
done

echo
#echo "Testing group $NUM control"
echo "Testing control"
for CTRL in gcc clang mingw turboc tasm
do
  echo $CTRL
  TESTDIR=observations/${CTRL}Test
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

