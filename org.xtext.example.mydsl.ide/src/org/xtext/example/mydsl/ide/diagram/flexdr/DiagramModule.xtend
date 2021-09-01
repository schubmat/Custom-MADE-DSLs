package org.xtext.example.mydsl.ide.diagram.flexdr

import org.eclipse.sprotty.xtext.DefaultDiagramModule
import org.eclipse.sprotty.xtext.IDiagramGenerator

class DiagramModule extends DefaultDiagramModule {
	
	def Class<? extends IDiagramGenerator> bindIDiagramGenerator() {
		DiagramGenerator
	} 
	
	override bindIDiagramServerFactory() {
		DiagramServerFactoryTool
	}
	
	override bindILayoutEngine() {
		LayoutEngine
	}
	
	override bindIDiagramServer() {
		DiagramServer
	}	
}
