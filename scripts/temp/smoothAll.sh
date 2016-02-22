#!/bin/sh
NUM=$1

echo "Smoothing all models for ${NUM} states"
for MODEL in gcc clang mingw turboc tasm ngvck metaphor
do
  echo "Building model for ${MODEL}"
  #./scripts/smoothModel.rb < models/${MODEL}Min-final-${NUM}.hmm > models/${MODEL}Min-smoothed-${NUM}.hmm
  ./scripts/smoothModel.rb < models/${MODEL}/final-st${NUM}-1.hmm > models/${MODEL}/smoothed-st${NUM}-1.hmm
  ./scripts/smoothModel.rb < models/${MODEL}/final-st${NUM}-2.hmm > models/${MODEL}/smoothed-st${NUM}-2.hmm
  ./scripts/smoothModel.rb < models/${MODEL}/final-st${NUM}-3.hmm > models/${MODEL}/smoothed-st${NUM}-3.hmm
  ./scripts/smoothModel.rb < models/${MODEL}/final-st${NUM}-4.hmm > models/${MODEL}/smoothed-st${NUM}-4.hmm
  ./scripts/smoothModel.rb < models/${MODEL}/final-st${NUM}-5.hmm > models/${MODEL}/smoothed-st${NUM}-5.hmm
done

