package org.xtext.example.mydsl.ide.diagram.flexdr

import org.eclipse.sprotty.xtext.DiagramServerFactory

class DiagramServerFactoryTool extends DiagramServerFactory {

	override getDiagramTypes() {
		#['flex-dr-based-diagram']
	}
}