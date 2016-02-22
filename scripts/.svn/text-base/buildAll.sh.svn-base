#!/bin/sh

TYPE=$1
TEST_TYPE=$2
TYPE_LOWER=`echo $TYPE | tr "[:upper:]" "[:lower:]"`
TRAIN_FILE=observations/${TYPE}${TEST_TYPE}-training.seq

echo "Rebuilding ${TRAIN_FILE}"
# Remove old observation file
rm ${TRAIN_FILE}
# Create observation file
for i in `ls rawData/${TYPE_LOWER}/*.asm`
do
  js -f x86.js/createObservation.js < $i >> ${TRAIN_FILE}
done

echo "Regenerating sequences for testing"
for i in `ls rawData/${TYPE_LOWER}Test/*.asm`
do
  js -f x86.js/createObservation.js < $i > $i.seq
done
mv rawData/${TYPE_LOWER}Test/*.seq observations/${TYPE_LOWER}${TEST_TYPE}Test/

echo
echo "Rebuilding ${TYPE} models"
./scripts/buildModel.sh $TYPE 2  ${TEST_TYPE}
./scripts/buildModel.sh $TYPE 3  ${TEST_TYPE}
./scripts/buildModel.sh $TYPE 4  ${TEST_TYPE}
#./scripts/buildModel.sh $TYPE 5  ${TEST_TYPE}
#./scripts/buildModel.sh $TYPE 6  ${TEST_TYPE}
#./scripts/buildModel.sh $TYPE 7  ${TEST_TYPE}
#./scripts/buildModel.sh $TYPE 8  ${TEST_TYPE}
#./scripts/buildModel.sh $TYPE 9  ${TEST_TYPE}
#./scripts/buildModel.sh $TYPE 10 ${TEST_TYPE}
#./scripts/buildModel.sh $TYPE 11 ${TEST_TYPE}

echo "Rebuilding Sliced ${TYPE} models"
./scripts/buildSliceModel.sh $TYPE 2
./scripts/buildSliceModel.sh $TYPE 3
./scripts/buildSliceModel.sh $TYPE 4

