package org.xtext.example.mydsl.ide.diagram.flexdr;

/**
 * A Binding is an information about one relation between an object from the grammar and the
 * FlexDRMetaModel.
 * 
 * A Bindings can have one of three "types":
 * 		- A structural Binding
 * 				This is to be used for a structural element. It knows the name of the class
 * 				from the grammar, which shall be binded and the corresponding structural 
 * 				Meta Model type.
 * 		- A connection Binding with existing Class
 * 				This is to be used for a connection element. It knows the name of the class
 * 				from the grammar, which shall be binded and the corresponding structural
 * 				Meta Model type. Additionally, information is given which type source and
 * 				target of the connection have.
 * 		- A connection Binding without existing Class
 * 				This is to be used for a connection element, which itself is not represented
 * 				within the grammar. It knows the type of the connection. Additionally, 
 * 				information is given which type source and target of the connection have.
 * 
 * 
 * @author Robert Richter
 * @date Refactored to own class at 04.06.2021 (formerly a static class within EMetaModelTypes).
 *
 */

class Binding {
	
	// The name of the class in the grammar.
	public String classToBeBinded
	// The meta model type, the class to be binded is derived from.
	public EMetaModelTypes type	
	// The parent type of the language type.
	public EMetaModelTypes parentType
	// The source of a connection
	public EMetaModelTypes source
	// The target of a connection
	public EMetaModelTypes target
	
	/**
	 * Use this constructor for structural elements.
	 */
	new(String classToBeBinded, EMetaModelTypes type) {		
		this.type = type
		this.classToBeBinded = classToBeBinded
		
		this.source = null
		this.target = null		
	}
	/**
	 * Or this one to enforce a specific parent type.
	 */
	new(String classToBeBinded, EMetaModelTypes type, EMetaModelTypes parentType) {
		this.type = type
		this.classToBeBinded = classToBeBinded
		
		this.parentType = parentType
		
		this.source = null
		this.target = null
	}
	
	/**
	 * Use this constructor for connection elements. It adds support for the type of souce and target.
	 */
	new(String classToBeBinded, EMetaModelTypes type, EMetaModelTypes source, EMetaModelTypes target) {
		this.type = type
		this.classToBeBinded = classToBeBinded
		
		this.parentType = null
		
		this.source = source
		this.target = target
	}
	/**
	 * Use this constructor for connection elements, which are not personally present in the grammar. 
	 * So you could just state, that every two structural element with a direct relation in the grammar,
	 * are to be connected with such an association, even though there is no class representing this relation.
	 * 
	 * @type
	 * 			A connection type.
	 * @source
	 * 			A structural type which is the source of an edge.
	 * @target
	 * 			A structural type which is the target of an edge.
	 * 
	 */
	new(EMetaModelTypes type, EMetaModelTypes source, EMetaModelTypes target) {
		this.classToBeBinded = null
		this.type = type
		
		this.parentType = null
		
		this.source = source
		this.target = target
	}
	
	def boolean isStructural() {
		return type.isStructural()
	}
	
	def boolean isConnection() {
		return type.isConnection()
	}
	
}