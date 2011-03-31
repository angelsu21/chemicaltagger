package uk.ac.cam.ch.wwmm.chemicaltagger;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.List;

import opennlp.tools.lang.english.PosTagger;
import opennlp.tools.postag.POSDictionary;

import org.apache.log4j.Logger;

/*****************************************************
 * Runs the OpenNLP tagger .
 * 
 * @author lh359, dmj30,jat45
 *****************************************************/
public class OpenNLPTagger {
	/**************************************
	 * Private Singleton holder.
	 ***************************************/
	private static final class INSTANCE_HOLDER {
		private static OpenNLPTagger myInstance = new OpenNLPTagger();
	}

	
	private PosTagger posTagger;
	private final static Logger LOG = Logger.getLogger(OscarTagger.class);

	/**************************************
	 * Private Constructor Class.
	 ***************************************/
	private OpenNLPTagger() {
		try {
			setUpPosTagger();
		} catch (IOException e) {
			LOG.error("Exception " + e.getMessage());
			throw new RuntimeException("Failed to initialise PosTagger", e);
		}
	}

	/**************************************
	 * @return OpenNLPTaggerInstance.
	 ***************************************/
	public static OpenNLPTagger getInstance() {
		return INSTANCE_HOLDER.myInstance;
	}

	/**************************************
	 * Getter method for posTagger.
	 * 
	 * @return posTagger(PosTagger).
	 ***************************************/
	public PosTagger getTagger() {
		return posTagger;
	}


	/*******************************************
	 * Loads the Brown corpus tags to POSTagger.
	 ***************************************/
	private void setUpPosTagger() throws IOException {
		InputStreamReader tagDictReader = null;
		new Utils();
		InputStream in = Utils.getInputStream(getClass(),"/uk/ac/cam/ch/wwmm/chemicaltagger/openNLPTagger/tagdict");
		tagDictReader = new InputStreamReader(in);
		String filepath = getClass().getClassLoader().getResource("uk/ac/cam/ch/wwmm/chemicaltagger/openNLPTagger/tag.bin").getPath();
		POSDictionary tagDict = new POSDictionary(new BufferedReader(tagDictReader), true);
		posTagger = new PosTagger(filepath, tagDict);
	}

	/*****************************************************
	 * Runs the OpenNLP brown tagger against the text and stores the tags in
	 * POSContainer.
	 *****************************************************/
	public POSContainer runTagger(POSContainer posContainer) {
		List<String> tokenList = posContainer.getWordTokenList();
		String[] tokens = new String[tokenList.size()];
		for (int i = 0; i < tokenList.size(); i++) {
			tokens[i] = tokenList.get(i);
		}
		String[] tags = posTagger.tag(tokens);
		posContainer.createBrownTagListFromStringArray(tags);
		return posContainer;
	}

}
