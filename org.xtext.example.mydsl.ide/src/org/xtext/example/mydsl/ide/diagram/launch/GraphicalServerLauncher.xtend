package org.xtext.example.mydsl.ide.diagram.launch

import org.eclipse.sprotty.xtext.launch.DiagramServerLauncher
import java.util.logging.Logger
import java.util.Arrays

class GraphicalServerLauncher extends DiagramServerLauncher {
	
	public static DebugLogger log
	
	def static void main(String[] args) {
		log = new DebugLogger()
		System.err.println("Graphical Language Server started with: " + Arrays.toString(args))
		// log.log("Graphical Language Server started with: " + Arrays.toString(args))
		new GraphicalServerLauncher().run(args)
	}
	
	override createSetup() {
		new GraphicalLanguageServerSetup
	}
	
}