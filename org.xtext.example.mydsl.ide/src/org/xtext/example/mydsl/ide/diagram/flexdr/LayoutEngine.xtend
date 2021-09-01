package org.xtext.example.mydsl.ide.diagram.flexdr

import org.eclipse.sprotty.SGraph
import org.eclipse.sprotty.SModelRoot
import org.eclipse.sprotty.layout.ElkLayoutEngine
import org.eclipse.sprotty.layout.SprottyLayoutConfigurator
import org.eclipse.elk.alg.layered.options.LayeredOptions
import org.eclipse.elk.core.options.CoreOptions
import org.eclipse.elk.core.options.Direction
import org.eclipse.elk.core.options.PortSide
import org.eclipse.elk.core.options.PortAlignment
import org.eclipse.elk.core.options.PortConstraints
import org.eclipse.sprotty.Action

class LayoutEngine extends ElkLayoutEngine {
	
	/**
	 * TODO How to layout properly --> Probably not needed if graph is supposed to have
	 * a fixed layout.
	 */
	override layout(SModelRoot root, Action cause) {
		
		// Takes all defined MetaModelTypes.
		val allTypes = EMetaModelTypes.values()
		
		if (root instanceof SGraph) {
			// Preconfigured by Typefox example.
			val configurator = new SprottyLayoutConfigurator
			configurator.configureByType('graph')
				.setProperty(CoreOptions.DIRECTION, Direction.DOWN)
				.setProperty(CoreOptions.SPACING_NODE_NODE, 30.0)
				.setProperty(LayeredOptions.SPACING_EDGE_NODE_BETWEEN_LAYERS, 30.0)
			configurator.configureByType('node')
				.setProperty(CoreOptions.PORT_ALIGNMENT_DEFAULT, PortAlignment.CENTER)
				.setProperty(CoreOptions.PORT_CONSTRAINTS, PortConstraints.FIXED_SIDE)
			configurator.configureByType('port')
				.setProperty(CoreOptions.PORT_SIDE, PortSide.EAST)
				.setProperty((CoreOptions.PORT_BORDER_OFFSET), 3.0)
			layout(root, configurator, cause)
			
			// Additionally for FlexDRMetaModel
			for (type : allTypes) {				
				if (type.isConnection) {
					configurator.configureByType(type.toString)
						.setProperty(CoreOptions.PORT_ALIGNMENT_DEFAULT, PortAlignment.CENTER)
						.setProperty(CoreOptions.PORT_CONSTRAINTS, PortConstraints.FIXED_SIDE)
					configurator.configureByType('port')
						.setProperty(CoreOptions.PORT_SIDE, PortSide.EAST)
						.setProperty((CoreOptions.PORT_BORDER_OFFSET), 3.0)	 
				} else if (type.isStructural) {
				}				
			}
			
		}
	}
}