package org.xtext.example.mydsl.ide.diagram.launch

import org.eclipse.sprotty.xtext.launch.DiagramServerSocketLauncher

class GraphicalSocketServer extends DiagramServerSocketLauncher {
	
	override createSetup() {
		new GraphicalLanguageServerSetup
	}
	
	def static void main(String[] args) {
		new GraphicalSocketServer().run(args)
	}
	
}