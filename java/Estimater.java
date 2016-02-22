package edu.ucsc.virus;

import be.ac.ulg.montefiore.run.jahmm.apps.cli.WrongArgumentsException;
import java.io.Reader;
import be.ac.ulg.montefiore.run.jahmm.Hmm;
import be.ac.ulg.montefiore.run.jahmm.ObservationInteger;
import be.ac.ulg.montefiore.run.jahmm.io.FileFormatException;
import be.ac.ulg.montefiore.run.jahmm.io.HmmReader;
import be.ac.ulg.montefiore.run.jahmm.io.ObservationIntegerReader;
import be.ac.ulg.montefiore.run.jahmm.io.ObservationSequencesReader;
import be.ac.ulg.montefiore.run.jahmm.io.OpdfIntegerReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import static java.lang.System.out;
import static java.lang.System.err;

/**
 * Uses JAHMM to read in a HMM for a virus family and an opcode sequence
 * and print the result.
 * 
 * @author Tom Austin 
 */
public class Estimater {

  public static Hmm readHmm(String fileName)
          throws FileNotFoundException, IOException, FileFormatException {
    FileReader fr = new FileReader(fileName);
    OpdfIntegerReader oir = new OpdfIntegerReader();
    Hmm model = null;
    try {
      model = HmmReader.read(fr, oir);
    } catch (FileFormatException e) {
      err.println("Caught error trying to build HMM: " + e);
      throw e;
    }
    return model;
  }

  public static List<ObservationInteger> readObservationFile(String obsFile)
          throws FileNotFoundException, IOException, FileFormatException {
    ObservationIntegerReader or = new ObservationIntegerReader();
    Reader fr = new FileReader(obsFile);
    return ObservationSequencesReader.readSequence(or, fr);
  }

  /**
   * @param args the command line arguments
   */
  public static void main(String[] args) throws FileNotFoundException, IOException, FileFormatException {
    if (args.length < 2
            || ("-t".equals(args[0]) && args.length != 4)) {
      err.println("Usage: java edu.ucsc.virus.Estimater <observation file>"
              + " <hmm file 1> <hmm file 2> [... <hmm file N>]"
              + " or java edu.ucsc.virus.Estimater -t <observation file> <hmm file> <threshold>");
      System.exit(1);
    }
    // -t option specifies the threshold approach
    if ("-t".equals(args[0])) {
      ThresholdEstimater.runThresholdEstimater(args);
      return;
    }
    // Otherwise, dueling HMM strategy is used.
    String obsFile = args[0];
    try {
      Hmm[] hmms = new Hmm[args.length-1];
      String[] modelNames = new String[args.length-1];
      for (int i=1; i<args.length; i++) {
        String name = args[i];
        if (name.contains("/")) name = name.substring(name.lastIndexOf("/")+1);
        modelNames[i-1] = name;
        hmms[i-1] = readHmm(args[i]);
      }

      List<ObservationInteger> observations = readObservationFile(obsFile);

      String report = "";
      double best = Double.NEGATIVE_INFINITY;
      int bestInd = -1;
      for (int i=0; i<hmms.length; i++) {
        double prob = hmms[i].lnProbability(observations);
        if (Double.isNaN(prob)) prob = Double.NEGATIVE_INFINITY;
        else if (prob > best) {
          best = prob;
          bestInd = i;
        }
        String pStr = String.format("%8.2f", prob);
        report += "\t" + modelNames[i] + ":" + pStr;
      }

      if (bestInd == -1) report = "HMMs have an equal probability" + report;
      else report = "Best: *" + modelNames[bestInd] + "*" + report;
      out.println(report);
    }
    catch (Throwable t) {
      Logger.getLogger(Estimater.class.getName()).log(Level.SEVERE, null, t);
    }
  }
}
