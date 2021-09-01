package org.xtext.example.mydsl.ide.diagram.flexdr

import org.eclipse.sprotty.xtext.IDiagramGenerator
import org.eclipse.sprotty.xtext.IDiagramGenerator.Context
import org.eclipse.sprotty.SModelElement
import java.util.List
import org.eclipse.emf.ecore.EObject
import org.eclipse.sprotty.SGraph
import java.util.ArrayList
import org.xtext.example.mydsl.ide.diagram.flexdr.elements.StructuralElement
import org.xtext.example.mydsl.ide.diagram.flexdr.elements.ConnectionElement
import org.eclipse.sprotty.xtext.tracing.ITraceProvider
import com.google.inject.Inject
import org.eclipse.sprotty.xtext.SIssueMarkerDecorator
import org.eclipse.emf.ecore.EStructuralFeature
import java.util.logging.Logger
import java.util.logging.Level

class DiagramGenerator implements IDiagramGenerator {
	
	@Inject extension ITraceProvider
	@Inject extension SIssueMarkerDecorator
	
	Logger logger	
	List<Tuple<SModelElement, EObject>> crossReferences
	
	public String LABEL_ATTRIBUTE_NAME = "name"
	// If attribute "name" does not exist, use label. 
	// Using the attribute label, make the node unmodifiable.
	public String LABEL_FALLBACK_ATTRIBUTE_NAME = "label"
	List<Binding> bindings
	
	new() {
		// Get bindings set up by user.
		bindings = (new BindingsSetup()).bindings
		crossReferences = new ArrayList<Tuple<SModelElement, EObject>>()
		
		logger = Logger.getLogger("DiagramGenerator")
	}
	
	/**
	 * @returns SModelRoot
	 * 		Returns the schema of a sprotty graph. This includes a list of all diagram elements
	 * 		in the "children" attribute.
	 */
	override generate(Context context) {
		
		var model = context.resource.contents.head
				
		var graph = new SGraph()
		var root = new StructuralElement("Issue", false, "node", context, null, this)
			
		var children = new ArrayList<SModelElement>
		children.add(root)
		children.addAll(translateAstToDiagram(model, context, root, EMetaModelTypes.STATEMENT))
					
		graph.children = children
		
		// Remove everything from temporary memory.
		this.crossReferences.remove(true)
		
		return graph
	
	}
	
	/**
	 * Idea: Recursively parse each of the objects. Each objects is 
	 * an EObject, which is supposed to be translated into a diagram
	 * element.
	 * 
	 * The result of each recursive iteration is a list of diagram elements (and for each diagram element, its corresponding ast object is saved too).
	 */
	def List<SModelElement> translateAstToDiagram(
		EObject obj, Context context, SModelElement parent, EMetaModelTypes parentType
	) {
		// ---------- Find the binding ----------
		// Look up the binding.
		var binding = this.findBinding(obj, parentType)
	
		// Look up the child elements.
		val children = obj.eContents
		val diagramElements = new ArrayList<SModelElement>()
		
		// Test if representation is desired.
		if (binding === null) {			
			// Recursively finds representations for child elements.
			for (child : children) {
				diagramElements.addAll(
					translateAstToDiagram(
						child, context, parent, parentType
					)
				)
			}
			return diagramElements
		}
		
		// ---------- Get Label ----------
						
		// Create Node for currect object 
		val retrievedAttribute = getLabel(obj)
		val Object label = retrievedAttribute.label
		val modifiable = retrievedAttribute.modifiable
		
		var StructuralElement node;
		
		// ---------- Add diagram elements ----------
		if (binding.isConnection()) {
			/**
			 * "" 	--> No text
			 * binding.type.toString()
			 * 	  	--> Serialize the title to a text
			 * obj
			 * 		--> The AST-Object TODO Remove ! Not needed for connection element.
			 * context 
			 * 		--> The diagram context needed for performing ops on the whole diagram.
			 * parent
			 * 		--> Source
			 * null
			 * 		--> Target (still null)
			 * this
			 * 		--> Tracing methods ("TraceProvider") 
			 */
			val edge = new ConnectionElement("", binding.type.toString(), obj, context, parent, null, this)
			diagramElements.add(edge)
		} else {
			if (label instanceof String) {				
				
				if (binding.isStructural()) {
					node = new StructuralElement(label, modifiable, binding.type.toString(), context, obj, this)
					diagramElements.add(node)
					
					val tuple = new Tuple(node as SModelElement, obj)
					val reference = this.crossReferences.wasCrossReferenced(tuple)
					if (reference !== null) {							
						val refEdge = new ConnectionElement("", EMetaModelTypes.ARGUMENTATIVE_RELATIONSHIP.toString(), obj, context, node, reference, this)
						diagramElements.add(refEdge)
					}
					this.crossReferences.add(tuple)
					
					// If parent was no connection itself, add a connection to this structural child element.
					if (parentType.isStructural()) {
						var connectionBinding = findConnectionBinding(parentType, binding.type)
						if (connectionBinding === null) connectionBinding = findBindingSoft(parentType)

						if (connectionBinding !== null) {
							val edge = new ConnectionElement("", connectionBinding.type.toString(), obj, context, parent, node, this)
							diagramElements.add(edge)
						}
					} else {
						// If parent was a connection, set it's target to the new structural element.
						if (parentType.isConnection()) {
							if (parent instanceof ConnectionElement) {
								parent.setTarget(node.port.id)
							}
						}
						
					}
					
				}
				
			} else {
				if (label !== null) {
					if (label instanceof EObject) {
						diagramElements.addAll(
							translateAstToDiagram(
								label, context, parent, parentType
							)
						)
					}
				}
			}
		}
		
		for (child : children) {
			// The current object becomes the parent object.
			diagramElements.addAll(
				translateAstToDiagram(
					child, context, node, binding.type
				)
			)
		}
		return diagramElements 
		
	}
	
	/**
	 * ----------- Methods for finding the appropriate Binding -----------
	 */
	
	/** 
	 * Looks up the bindings "dictionary" to find the binding for the given object.
	 * 
	 * Based on the name of the class of the object (retrieved from EObject), the 
	 * name is looked up in the dictionary. 
	 * 
	 */
	def Binding findBinding(EObject obj, EMetaModelTypes parentType) {
		
		var Binding candidate = null
		for (binding : this.bindings) {
			val className = obj.class.simpleName
			val bindingClassName = binding.classToBeBinded
			
			if (className.equals(bindingClassName)) {
				if (binding.parentType !== null) {
					if (binding.parentType == parentType) {
						// This happens, when also the parent type is specified.
						// It would be a perfect match.
						candidate = new Binding(binding.classToBeBinded, binding.type)
					}
				} else {
					candidate = binding
				}
			}
		}
		return candidate
	}
	
	/**
	 * Looks up the bindings "dictionary" to find the binding for the given object.
	 * 
	 * Based on the type of the source and target, a binding is searched. 
	 * If a perfect match is found, it will be returned. 
	 */
	def Binding findConnectionBinding(EMetaModelTypes source, EMetaModelTypes target) {		
		for (binding : this.bindings) {
			val sourceType = binding.source
			val targetType = binding.target
			
			// Makes sure the current binding is used for a connection.
			if (sourceType !== null && targetType !== null) {
				if (source.equals(sourceType) && target.equals(targetType)) {
					return binding
				} 				
			}			
		}
		return null		
	}
	/**
	 * This methods checks, if the source of a binding matches the given type.
	 * The first binding to match, will be returned.
	 */
	def Binding findBindingSoft(EMetaModelTypes source) {
		for (binding : this.bindings) {
			val sourceType = binding.source
			
			// Makes sure the current binding is used for a connection.
			if (sourceType !== null) {
				if (source.equals(sourceType)) {
					return binding
				} 				
			}			
		}
		return null		
	}
	
	/**
	 * Searches for the label value of a given EObject. If not found, returns null.
	 */
	def RetrievedAttribute getLabel(EObject obj) {
		try {
			val label = AttributeManager.getProperty(obj, this.LABEL_ATTRIBUTE_NAME)
			return (new RetrievedAttribute(label, true))
		} catch (Exception e) {
			try {
				val label = AttributeManager.getProperty(obj, this.LABEL_FALLBACK_ATTRIBUTE_NAME)
				return (new RetrievedAttribute(label, false))
			} catch (Exception e2) {}			
		}
		// Both attributes for labels are not found.
		return null;
	}
	
	def <T extends SModelElement> T traceElement(T traceable, EObject source) {
		trace(traceable, source)
	}

	def <T extends SModelElement> T traceElement(T traceable, EObject source, EStructuralFeature feature, int index) {
		trace(traceable, source, feature, index)
	}
	
	
	def <T extends SModelElement> T traceAndMark(T sElement, EObject element, Context context) {
		sElement.trace(element).addIssueMarkers(element, context) 
	} 
	
	def SModelElement wasCrossReferenced(
		List<Tuple<SModelElement, EObject>> objects, Tuple<SModelElement, EObject> curr
	) {
		for (obj : objects) {
			if (obj.second.equals(curr.second)) {
				return obj.first
			}
		}
		return null		
	}
	
	/**
	 * Helper class to determine both, a String and a flag if an AST-object is supposed to be modifiable.
	 */
	private static class RetrievedAttribute {
		boolean modifiable
		Object label
		new(Object label, boolean modifiable) {
			// The AST-object, which got the attribute "label". Not necessarily a String.
			this.label = label
			// The flag, which is process earlier.
			this.modifiable = modifiable
		}
	}
	
	/**
	 * Tuple helper class 
	 */
	 private static class Tuple<X, Y> {
	 	public final X first
	 	public final Y second
	 	new(X x, Y y) {
	 		this.first = x
	 		this.second = y
	 	}
	 }
	
	
}