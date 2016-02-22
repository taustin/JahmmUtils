#!/bin/sh
NUM=$1

echo "Smoothing all models for ${NUM} states"
for MODEL in GCC CLANG MINGW TURBOC TASM NGVCK METAPHOR G2
do
  echo "Building model for ${MODEL}"
  ./scripts/smoothModel.rb < models/${MODEL}-final-${NUM}.hmm > models/${MODEL}-smoothed-${NUM}.hmm
done

