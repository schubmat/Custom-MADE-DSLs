package org.xtext.example.mydsl.ide.diagram.flexdr

import java.util.List
import java.util.ArrayList
import org.xtext.example.mydsl.myDsl.impl.*

class BindingsSetup {
	
	List<Binding> bindings
	
	new() {
		
		bindings = new ArrayList<Binding>()
		/*
		 * Binding have the style: 
		 * new Binding(TitleImpl.simpleName, EMetaModelTypes.STATEMENT),
		 * new Binding(LineImpl.simpleName, EMetaModelTypes.ARGUMENTATIVE_RELATIONSHIP),
		 * ...
		 * 
		 * To be concrete, there are three kinds of bindings. For detailed information, see
		 * Binding.xtend.
		 * 
		 */
		bindings.addAll(
			
			/*
			 * What does this mean?
			 * 		This binds a title to a specific meta model type.
			 * 		Parameter 1: The M1 language element
			 * 		Parameter 2: The M2 meta model type the M1 language was derived from. 
			 */		
			new Binding(TitleImpl.simpleName, EMetaModelTypes.STATEMENT),
			new Binding(SummaryImpl.simpleName, EMetaModelTypes.STATEMENT),
			new Binding(AlternativeImpl.simpleName, EMetaModelTypes.DECISION_OPTION),
			new Binding(AlternativeImpl.simpleName, EMetaModelTypes.DECISION_RESULT, EMetaModelTypes.STATEMENT),
			new Binding(AlternativesImpl.simpleName, EMetaModelTypes.DECISION_PROBLEM),
			new Binding(BecauseImpl.simpleName, EMetaModelTypes.STATEMENT),
			new Binding(ChosenAlternativeImpl.simpleName, EMetaModelTypes.DECISION_RESULT),
			new Binding(OutcomeImpl.simpleName, EMetaModelTypes.STATEMENT),
			new Binding(RationaleImpl.simpleName, EMetaModelTypes.DROBJECT),
			new Binding(UserStoryImpl.simpleName, EMetaModelTypes.STATEMENT),
			new Binding(ChosenAlternativeImpl.simpleName, EMetaModelTypes.DECISION_RESULT),
			
			/*
			 * What does this mean?
			 * 		This specifies the relation between two meta model types.
			 * 		Parameter 1: The relationship, which is supposed to be used for the edge.
			 * 		Parameter 2: The source element.
			 * 		Parameter 3: The target element. 
			 */			
			new Binding(EMetaModelTypes.OPTION_RELATIONSHIP, EMetaModelTypes.DECISION_PROBLEM, EMetaModelTypes.DECISION_OPTION),
			new Binding(EMetaModelTypes.ARGUMENTATIVE_RELATIONSHIP, EMetaModelTypes.STATEMENT, EMetaModelTypes.STATEMENT),
			new Binding(EMetaModelTypes.CONSEQUENCE_RELATIONSHIP, EMetaModelTypes.STATEMENT, EMetaModelTypes.DECISION_RESULT),
			new Binding(EMetaModelTypes.CONSEQUENCE_RELATIONSHIP, EMetaModelTypes.STATEMENT, EMetaModelTypes.DROBJECT),
			new Binding(EMetaModelTypes.DERIVATIVE_RELATIONSHIP, EMetaModelTypes.DECISION_OPTION, EMetaModelTypes.DECISION_RESULT)			
			
			
		)
		
	}
	
	def getBindings() {
		return this.bindings
	}
	
}