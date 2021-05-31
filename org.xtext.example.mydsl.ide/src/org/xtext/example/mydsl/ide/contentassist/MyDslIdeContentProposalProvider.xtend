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

			acceptor.accept(proposalCreator.createSnippet('''Language Name: LANGUAGE_ID

	Language Types:
		DR Obejct -- Type: Decision-Problem
			Name: Issue
			ID: DP_ISSUE
		DR Obejct -- Type: Decision-Option
			Name: Alternative
			ID: DO_ALT
		DR Obejct -- Type: Decision-Result
			Name: SelectedAlternative
			ID: DR_SEL_ALT

	Assocations:
''', "Complete Template", context), 0)
		}

		super._createProposals(ruleCall, context, acceptor)
	}

}
