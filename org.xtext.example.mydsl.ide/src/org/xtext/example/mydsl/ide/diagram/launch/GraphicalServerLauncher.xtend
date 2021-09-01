package org.xtext.example.mydsl.ide.diagram.launch

import org.eclipse.sprotty.xtext.launch.DiagramServerLauncher
import java.util.logging.Logger

class GraphicalServerLauncher extends DiagramServerLauncher {
	
	public static DebugLogger log
	
	def static void main(String[] args) {
		log = new DebugLogger()
		// log.log("Graphical Language Server started.")
		new GraphicalServerLauncher().run(args)
	}
	
	override createSetup() {
		new GraphicalLanguageServerSetup
	}
	
}