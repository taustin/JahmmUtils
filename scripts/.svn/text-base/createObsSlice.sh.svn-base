#!/bin/sh

TYPE=$1
TYPE_LOWER=`echo $TYPE | tr "[:upper:]" "[:lower:]"`

./scripts/createTestObservations.sh ${TYPE_LOWER} 1
./scripts/createTestObservations.sh ${TYPE_LOWER} 2
./scripts/createTestObservations.sh ${TYPE_LOWER} 3
./scripts/createTestObservations.sh ${TYPE_LOWER} 4
./scripts/createTestObservations.sh ${TYPE_LOWER} 5

cat observations/${TYPE_LOWER}/2/*.seq observations/${TYPE_LOWER}/3/*.seq observations/${TYPE_LOWER}/4/*.seq observations/${TYPE_LOWER}/5/*.seq > observations/${TYPE_LOWER}/train-1.seq
cat observations/${TYPE_LOWER}/1/*.seq observations/${TYPE_LOWER}/3/*.seq observations/${TYPE_LOWER}/4/*.seq observations/${TYPE_LOWER}/5/*.seq > observations/${TYPE_LOWER}/train-2.seq
cat observations/${TYPE_LOWER}/1/*.seq observations/${TYPE_LOWER}/2/*.seq observations/${TYPE_LOWER}/4/*.seq observations/${TYPE_LOWER}/5/*.seq > observations/${TYPE_LOWER}/train-3.seq
cat observations/${TYPE_LOWER}/1/*.seq observations/${TYPE_LOWER}/2/*.seq observations/${TYPE_LOWER}/3/*.seq observations/${TYPE_LOWER}/5/*.seq > observations/${TYPE_LOWER}/train-4.seq
cat observations/${TYPE_LOWER}/1/*.seq observations/${TYPE_LOWER}/2/*.seq observations/${TYPE_LOWER}/3/*.seq observations/${TYPE_LOWER}/4/*.seq > observations/${TYPE_LOWER}/train-5.seq

