package org.xtext.example.mydsl.ide.diagram.flexdr.elements

import org.eclipse.sprotty.SEdge
import org.eclipse.emf.ecore.EObject
import org.eclipse.sprotty.xtext.IDiagramGenerator.Context
import org.eclipse.sprotty.SModelElement
import org.xtext.example.mydsl.ide.diagram.flexdr.DiagramGenerator

class ConnectionElement extends SEdge {

	new(String label, String type, 
		EObject astObject, Context context, 
		SModelElement source, SModelElement target,
		DiagramGenerator traceProvider
	){
		super()

		this.setType(type.toLowerCase())
		
		this.id = context.idCache.uniqueId(label + "." + type)
		this.sourceId = source.id
		this.targetId = target.id
	}
	
	def setSource(String id) {
		this.sourceId = id
	}
	
	def getSource() {
		return this.sourceId
	}
	
	def setTarget(String id) {
		this.targetId = id
	}
	
	def getTarget() {
		return this.targetId
	}
	
}