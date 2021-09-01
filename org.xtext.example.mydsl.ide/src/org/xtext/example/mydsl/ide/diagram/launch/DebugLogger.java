package org.xtext.example.mydsl.ide.diagram.launch;

import java.util.logging.Logger;

public class DebugLogger {
	
	private static Logger logger;
	
	DebugLogger() {
		this.logger = Logger.getLogger("Info Logger");
	}
	
	public void log(String message) {
		this.logger.info(message);
	}

}
