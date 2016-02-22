package edu.ucsc.virus;

import be.ac.ulg.montefiore.run.jahmm.Hmm;
import be.ac.ulg.montefiore.run.jahmm.ObservationInteger;
import be.ac.ulg.montefiore.run.jahmm.io.FileFormatException;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.List;

/**
 * This estimater compares a file to the HMM and tests to see if it lies within
 * a certain threshold value.  This is in contrast to the other estimater which
 * tests different models and attempts to choose the most likely based on which
 * has the highest probability.
 * 
 * The benefit of this approach is that we can tweak the thresholds easily to
 * set the amount of false positives that are acceptable.
 * 
 * @author Tom Austin
 */
public class ThresholdEstimater {

  private Hmm hmm;
  private double threshold;

  public ThresholdEstimater(String hmmFileName, double threshold)
          throws FileNotFoundException, IOException, FileFormatException {
    this.hmm = Estimater.readHmm(hmmFileName);
    this.threshold = threshold;
  }

  public double seqProbabilityNorm(List<ObservationInteger> observations) {
    return hmm.lnProbability(observations) / observations.size();
  }

  public String evaluateSequence(List<ObservationInteger> observations) {
    double normProb = this.seqProbabilityNorm(observations);
    return normProb + ((normProb > threshold) ? "\t**MATCHES** ": "\tN");
  }

  public static void runThresholdEstimater(String[] args) throws IOException, FileFormatException {
    String obsFile = args[1];
    String hmmFile = args[2];
    double threshold = Double.parseDouble(args[3]);

    ThresholdEstimater te = new ThresholdEstimater(hmmFile, threshold);

    List<ObservationInteger> observations = Estimater.readObservationFile(obsFile);

    //out.println(te.seqProbabilityNorm(observations));
    System.out.println(te.evaluateSequence(observations));
  }

}
