/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package jsentiment;

import gnu.prolog.database.PrologTextLoaderError;
import gnu.prolog.demo.mentalarithmetic.NoAnswerException;
import gnu.prolog.io.TermWriter;
import gnu.prolog.term.AtomTerm;
import gnu.prolog.term.CompoundTerm;
import gnu.prolog.term.IntegerTerm;
import gnu.prolog.term.DoubleQuotesTerm;
import gnu.prolog.term.Term;
import gnu.prolog.term.VariableTerm;
import gnu.prolog.vm.Environment;
import gnu.prolog.vm.Interpreter;
import gnu.prolog.vm.PrologCode;
import gnu.prolog.vm.PrologException;
import gnu.prolog.vm.TermConstants;
import java.util.List;

/**
 *
 * @author lefterisLapdance
 */
public class JSentimentBehavior {
    
    
    private static boolean issetup = false;
    private static Environment env;
    private static Interpreter interpreter;
    
    // Create the answer
    private String answer = new String();
                
    public JSentimentBehavior(){}
    
    public String getAnswer(String input) throws PrologException, NoAnswerException{
        return generateQuestion(input);
    }
    
    private String generateQuestion(String input) throws PrologException, NoAnswerException{
		setup();
		// // Construct the question.
		// Create variable terms so that we can pull the answers out later
		VariableTerm listTerm = new VariableTerm("List");
		VariableTerm answerTerm = new VariableTerm("Answer");
		// Create the arguments to the compound term which is the question
                
                Term[] args = { AtomTerm.get(input), new VariableTerm("Answer") ,listTerm, answerTerm };
		// Construct the question
		CompoundTerm goalTerm = new CompoundTerm(AtomTerm.get("sentiment"), args);

		synchronized (interpreter)// so that this class is thread safe.
		{
				
			// Print out any errors
			debug();

			// Execute the goal and return the return code.
			int rc = interpreter.runOnce(goalTerm);

			// If it succeeded.
			if (rc == PrologCode.SUCCESS || rc == PrologCode.SUCCESS_LAST)
			{

				// Get hold of the actual Terms which the variable terms point to
				Term list = listTerm.dereference();
				Term value = answerTerm.dereference();
				// Check it is valid
				if (list != null)
				{
					if (list instanceof CompoundTerm)
					{
						CompoundTerm cList = (CompoundTerm) list;
						if (cList.tag == TermConstants.listTag)// it is a list
						{// Turn it into a string to use.
							answer = TermWriter.toString(list);
						}
						else
						{
							throw new NoAnswerException("List is not a list but is a CompoundTerm: " + list);
						}
                                        }
                                }
                        }
                        else{
                             throw new NoAnswerException("Goal failed");
                        }
                }
                return answer;
	}
        

	/**
	 * Ensure that we have an environment and have loaded the prolog code and have
	 * an interpreter to use.
	 */
	private synchronized void setup()
	{
		if (issetup)
		{
			return;// don't setup more than once
		}

		// Construct the environment
		env = new Environment();

		// get the filename relative to the class file
		env.ensureLoaded(AtomTerm.get(JSentiment.class.getResource("dict.pro").getFile()));
		env.ensureLoaded(AtomTerm.get(JSentiment.class.getResource("jsentiment.pro").getFile()));

		// Get the interpreter.
		interpreter = env.createInterpreter();
		// Run the initialization
		env.runInitialization(interpreter);

		// So that we don't repeat ourselves
		issetup = true;
	}

	/**
	 * Collect debugging information if something has gone wrong in particular get
	 * any {@link PrologTextLoaderError PrologTextLoaderErrors} which were created
	 * during loading.
	 */
	private void debug()
	{
		List<PrologTextLoaderError> errors = env.getLoadingErrors();
		for (PrologTextLoaderError error : errors)
		{
			error.printStackTrace();
		}

		/*
		 * Map<AtomTerm, Term> atom2flag = env.getPrologFlags(); Set<AtomTerm> atoms
		 * = atom2flag.keySet(); for (AtomTerm a : atoms) {
		 * System.out.println(a.toString() + " => " + atom2flag.get(a)); }
		 */
	}
}
