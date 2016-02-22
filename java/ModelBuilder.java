package edu.ucsc.virus;

import be.ac.ulg.montefiore.run.jahmm.Hmm;
import be.ac.ulg.montefiore.run.jahmm.ObservationInteger;
import be.ac.ulg.montefiore.run.jahmm.Opdf;
import be.ac.ulg.montefiore.run.jahmm.OpdfFactory;
import be.ac.ulg.montefiore.run.jahmm.OpdfIntegerFactory;
import be.ac.ulg.montefiore.run.jahmm.apps.cli.RelatedObjs;
import be.ac.ulg.montefiore.run.jahmm.apps.cli.WrongArgumentsException;
import be.ac.ulg.montefiore.run.jahmm.io.FileFormatException;
import be.ac.ulg.montefiore.run.jahmm.io.ObservationIntegerReader;
import be.ac.ulg.montefiore.run.jahmm.io.ObservationIntegerWriter;
import be.ac.ulg.montefiore.run.jahmm.io.ObservationReader;
import be.ac.ulg.montefiore.run.jahmm.io.ObservationSequencesReader;
import be.ac.ulg.montefiore.run.jahmm.io.ObservationWriter;
import be.ac.ulg.montefiore.run.jahmm.io.OpdfIntegerReader;
import be.ac.ulg.montefiore.run.jahmm.io.OpdfIntegerWriter;
import be.ac.ulg.montefiore.run.jahmm.io.OpdfReader;
import be.ac.ulg.montefiore.run.jahmm.io.OpdfWriter;
import be.ac.ulg.montefiore.run.jahmm.learn.KMeansLearner;
import be.ac.ulg.montefiore.run.jahmm.toolbox.MarkovGenerator;
import java.io.FileReader;
import java.io.IOException;
import java.io.Reader;
import java.util.List;

import static java.lang.System.out;

/**
 * Builds an HMM from a collection of observation sequences
 * using JAHMM.
 * 
 * @author Tom Austin
 */
public class ModelBuilder {
  private final int nbStates;

  public ModelBuilder(int nbStates) {
    this.nbStates = nbStates;
  }
  
  private Hmm learnInitial(RelatedObjs<ObservationInteger> relatedObjs, Reader reader)
          throws IOException, FileFormatException {
    out.println("Learning initial model");
		OpdfFactory<? extends Opdf<ObservationInteger>> opdfFactory = relatedObjs.opdfFactory();
    out.println("Reading sequences");
		List<List<ObservationInteger>> seqs = relatedObjs.readSequences(reader);
    //out.println("Creating a writer?");
		//OpdfWriter<? extends Opdf<ObservationInteger>> opdfWriter = relatedObjs.opdfWriter();
		
    out.println("Creating learner");
		KMeansLearner<ObservationInteger> kl = new KMeansLearner<ObservationInteger>(nbStates, opdfFactory, seqs);
    out.println("Learning time...");
		return kl.iterate();
	}

  private Hmm perfect(Hmm initial) {
    return initial;
  }

  public Hmm build(String obsFileName) throws IOException, FileFormatException, WrongArgumentsException {
    Reader r = new FileReader(obsFileName);
    Hmm initial = this.learnInitial(new IntegerRelatedObjects(nbStates), r);
    out.println("Learned initial model");
    return perfect(initial);
  }
  
}

/**
 * Copied shamelessly from code in the JAHMM command line tool.
 */
class IntegerRelatedObjects implements RelatedObjs<ObservationInteger> {
  final int range;
	
  /**
   * Slight deviation from copied code -- range is specified as a parameter.
   * 
   * @param range
   * @throws WrongArgumentsException 
   */
	public IntegerRelatedObjects(int range) throws WrongArgumentsException {
		this.range = range;
	}
	
  @Override
	public ObservationReader<ObservationInteger> observationReader() {
		return new ObservationIntegerReader(range);
	}
	
  @Override
	public ObservationWriter<ObservationInteger> observationWriter() {
		return new ObservationIntegerWriter();
	}
	
  @Override
	public OpdfFactory<? extends Opdf<ObservationInteger>> opdfFactory() {
		return new OpdfIntegerFactory(range);
	}
	
  @Override
	public OpdfReader<? extends Opdf<ObservationInteger>> opdfReader() {
		return new OpdfIntegerReader(range);
	}
	
  @Override
	public OpdfWriter<? extends Opdf<ObservationInteger>> opdfWriter() {
		return new OpdfIntegerWriter();
	}
	
	
  @Override
	public List<List<ObservationInteger>> readSequences(Reader reader) throws FileFormatException, IOException {
		return ObservationSequencesReader.readSequences(observationReader(), reader);
	}
	
  @Override
	public MarkovGenerator<ObservationInteger> generator(Hmm<ObservationInteger> hmm) {
		return new MarkovGenerator<ObservationInteger>(hmm);
	}
}
