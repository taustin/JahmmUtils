#!/bin/sh

JAHMM_LIB=lib/jahmm-0.6.3.jar
JAVA_CMD="java -classpath ${JAHMM_LIB} be.ac.ulg.montefiore.run.jahmm.apps.cli.Cli"

# Parameters to tweak for building the HMM
TYPE=$1
NUM_STATES=$2
NUM_POSS_OBS=234
NUM_ITERATIONS=500
TYPE_LOWER=`echo $TYPE | tr "[:upper:]" "[:lower:]"`

for SLICE in 1 2 3 4 5
do
  TRAIN_SEQ=observations/${TYPE_LOWER}/train-${SLICE}.seq
  INIT_HMM=models/${TYPE_LOWER}/initial-${SLICE}.hmm
  FINAL_HMM=models/${TYPE_LOWER}/final-st${NUM_STATES}-${SLICE}.hmm
  SMOOTH_HMM=models/${TYPE_LOWER}/smoothed-st${NUM_STATES}-${SLICE}.hmm

  echo "Building initial model with kmeans"
  $JAVA_CMD learn-kmeans -opdf integer -r ${NUM_POSS_OBS} -n ${NUM_STATES} -is ${TRAIN_SEQ} -o ${INIT_HMM}

  echo "Building final model with baum-welch"
  $JAVA_CMD learn-bw -opdf integer -r ${NUM_POSS_OBS} -is ${TRAIN_SEQ} -ni ${NUM_ITERATIONS} -i ${INIT_HMM} -o ${FINAL_HMM}

  echo "Smoothing final model"
  ./scripts/smoothModel.rb < ${FINAL_HMM} > ${SMOOTH_HMM}
done

