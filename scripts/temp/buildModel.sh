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
TRAIN_SEQ=observations/${TYPE}/train-
INIT_HMM=models/${TYPE}/initial-
FINAL_HMM=models/${TYPE}/final-st${NUM_STATES}-
#TRAIN_SEQ=observations/${TYPE}${TEST_TYPE}-training.seq
#INIT_HMM=models/${TYPE}${TEST_TYPE}-initial.hmm
#FINAL_HMM=models/${TYPE}${TEST_TYPE}-final-${NUM_STATES}.hmm
NUM_ITERATIONS=500

echo "Building initial models with kmeans"
$JAVA_CMD learn-kmeans -opdf integer -r ${NUM_POSS_OBS} -n ${NUM_STATES} -is ${TRAIN_SEQ}1.seq -o ${INIT_HMM}1.hmm
$JAVA_CMD learn-kmeans -opdf integer -r ${NUM_POSS_OBS} -n ${NUM_STATES} -is ${TRAIN_SEQ}2.seq -o ${INIT_HMM}2.hmm
$JAVA_CMD learn-kmeans -opdf integer -r ${NUM_POSS_OBS} -n ${NUM_STATES} -is ${TRAIN_SEQ}3.seq -o ${INIT_HMM}3.hmm
$JAVA_CMD learn-kmeans -opdf integer -r ${NUM_POSS_OBS} -n ${NUM_STATES} -is ${TRAIN_SEQ}4.seq -o ${INIT_HMM}4.hmm
$JAVA_CMD learn-kmeans -opdf integer -r ${NUM_POSS_OBS} -n ${NUM_STATES} -is ${TRAIN_SEQ}5.seq -o ${INIT_HMM}5.hmm

echo "Building final models with baum-welch"
$JAVA_CMD learn-bw -opdf integer -r ${NUM_POSS_OBS} -is ${TRAIN_SEQ}1.seq -ni ${NUM_ITERATIONS} -i ${INIT_HMM}1.hmm -o ${FINAL_HMM}1.hmm
$JAVA_CMD learn-bw -opdf integer -r ${NUM_POSS_OBS} -is ${TRAIN_SEQ}2.seq -ni ${NUM_ITERATIONS} -i ${INIT_HMM}2.hmm -o ${FINAL_HMM}2.hmm
$JAVA_CMD learn-bw -opdf integer -r ${NUM_POSS_OBS} -is ${TRAIN_SEQ}3.seq -ni ${NUM_ITERATIONS} -i ${INIT_HMM}3.hmm -o ${FINAL_HMM}3.hmm
$JAVA_CMD learn-bw -opdf integer -r ${NUM_POSS_OBS} -is ${TRAIN_SEQ}4.seq -ni ${NUM_ITERATIONS} -i ${INIT_HMM}4.hmm -o ${FINAL_HMM}4.hmm
$JAVA_CMD learn-bw -opdf integer -r ${NUM_POSS_OBS} -is ${TRAIN_SEQ}5.seq -ni ${NUM_ITERATIONS} -i ${INIT_HMM}5.hmm -o ${FINAL_HMM}5.hmm

