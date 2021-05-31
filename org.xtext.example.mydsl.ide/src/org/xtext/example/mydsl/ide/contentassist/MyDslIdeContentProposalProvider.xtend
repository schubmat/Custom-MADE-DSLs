package org.xtext.example.mydsl.ide.contentassist

import com.google.inject.Inject
import org.eclipse.xtext.RuleCall
import org.eclipse.xtext.ide.editor.contentassist.ContentAssistContext
import org.eclipse.xtext.ide.editor.contentassist.IIdeContentProposalAcceptor
import org.eclipse.xtext.ide.editor.contentassist.IdeContentProposalProvider
import org.eclipse.xtext.scoping.IScopeProvider
import org.xtext.example.mydsl.services.MyDslGrammarAccess

class MyDslIdeContentProposalProvider extends IdeContentProposalProvider {

	@Inject extension MyDslGrammarAccess

	@Inject IScopeProvider scopeProvider

	override protected _createProposals(RuleCall ruleCall, ContentAssistContext context,
		IIdeContentProposalAcceptor acceptor) {

		// Considered Alternatives
		if (modelRootRule == ruleCall.rule && context.currentModel !== null) {

			acceptor.accept(proposalCreator.createSnippet('''
				Language Name: LANGUAGE_ID
				
				DSL Type Definition:
				    DR Object -- Type: Decision-Problem:
				        ID: DP_ISSUE
				        Name: "Issue"
				    DR Object -- Type: Decision-Option:
				        ID: DO_ALT
				        Name: "Alternative"
				    DR Object -- Type: Decision-Result:
				        ID: DR_SEL_ALT
				        Name: "SelectedAlternative"
				
				    Associations:
				        Argumentative Relationship:
				            Source: Statement:
				                ID: DR_STATEMENT
				                Name: "Statement: "
				            Source Cardinality: 
				                "1"
				            Target: 
				                DR Object -- Type: Statement:
				                    ID: DR_STATEMENT
				                    Name: "Statement: "
				            Target Cardinality: 
				                "1"
				        Option Relationship:
				            Source: Decision-Problem:
				                ID: DP_ISSUE
				                Name: "Issue"
				            Source Cardinality: 
				                "1"
				            Target: Decision-Option:
				                ID: DO_ALT
				                Name: "Alternative"
				            Target Cardinality: 
				                "[2..*]" 
''', "Complete Template", context), 0)
		}

		super._createProposals(ruleCall, context, acceptor)
	}

}
