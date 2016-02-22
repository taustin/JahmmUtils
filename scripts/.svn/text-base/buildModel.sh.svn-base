#!/bin/sh

JAHMM_LIB=lib/jahmm-0.6.3.jar
JAVA_CMD="java -classpath ${JAHMM_LIB} be.ac.ulg.montefiore.run.jahmm.apps.cli.Cli"

# Parameters to tweak for building the HMM
TYPE=$1
NUM_STATES=$2
TEST_TYPE=$3
NUM_POSS_OBS=234
#NUM_POSS_OBS=14
#NUM_POSS_OBS=235
TRAIN_SEQ=observations/${TYPE}${TEST_TYPE}-training.seq
INIT_HMM=models/${TYPE}${TEST_TYPE}-initial.hmm
FINAL_HMM=models/${TYPE}${TEST_TYPE}-final-${NUM_STATES}.hmm
SMOOTH_HMM=models/${TYPE}${TEST_TYPE}-smoothed-${NUM_STATES}.hmm
NUM_ITERATIONS=500

echo "Building initial model with kmeans"
$JAVA_CMD learn-kmeans -opdf integer -r ${NUM_POSS_OBS} -n ${NUM_STATES} -is ${TRAIN_SEQ} -o ${INIT_HMM}

echo "Building final model with baum-welch"
$JAVA_CMD learn-bw -opdf integer -r ${NUM_POSS_OBS} -is ${TRAIN_SEQ} -ni ${NUM_ITERATIONS} -i ${INIT_HMM} -o ${FINAL_HMM}

echo "Smoothing final model"
./scripts/smoothModel.rb < ${FINAL_HMM} > ${SMOOTH_HMM}

