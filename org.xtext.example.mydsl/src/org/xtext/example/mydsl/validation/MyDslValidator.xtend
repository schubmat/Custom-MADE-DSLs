/*
 * generated by Xtext 2.16.0
 */
package org.xtext.example.mydsl.validation

import org.eclipse.xtext.validation.Check
// import org.eclipse.xtext.Alternatives
import org.xtext.example.mydsl.myDsl.MyDslPackage
import org.xtext.example.mydsl.myDsl.Feed

//import org.eclipse.xtext.util.internal.Log

/**
 * This class contains custom validation rules. 
 *
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#validation
 */
class MyDslValidator extends AbstractMyDslValidator {
	
	public static val INVALID_NAME = 'invalidName'
	
	@Check
	def checkNumberOfArticles(Feed feed) {
		
	}
	
/*
	@Check
	def checkNumberOfAlternatives(DecisionRecord record) {
		
		if (record.consideredAlteratives.alternatives.size < 2) {
			warning('There should be two alternatives to choose from at least!',
				MyDslPackage.Literals.DECISION_RECORD__CONSIDERED_ALTERATIVES,
				INVALID_NAME
			)
		}
	}
	
	@Check
	def checkTitleStartsWithCaptial(Title title) {
		if (!Character.isUpperCase(title.name.charAt(0))) {
			warning('Name should start with a capital', 
					MyDslPackage.Literals.TITLE__NAME,
					INVALID_NAME)
		}
	}
 */
}
