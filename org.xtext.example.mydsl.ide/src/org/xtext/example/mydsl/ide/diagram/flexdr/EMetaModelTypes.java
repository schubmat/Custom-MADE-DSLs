package org.xtext.example.mydsl.ide.diagram.flexdr;

import java.util.List;

import org.eclipse.emf.ecore.EObject;
import org.xtext.example.mydsl.ide.diagram.launch.GraphicalServerLauncher;

/**
 * 
 * @author Robert Richter
 * @date 21st April 2021
 * @organization Brandenburgisch-Technische Universität Cottbus-Senftenberg
 * @chair Software-Systems Engineering
 * 
 * Elements are taken from FlexDRMetaModel. Each object gets assigned a special type,
 * which is translated to a representation in the frontend.
 * 
 */
public enum EMetaModelTypes {

	// Structural Elements
	DROBJECT ("Drobject"),
	STATEMENT ("Statement"),
	DECISION_PROBLEM_OR_RESULT ("Decision_problem_or_result"),
	DECISION_PROBLEM ("Decision_problem"),
	DECISION_RESULT ("Decision_result"),
	DECISION_OPTION ("Decision_option"),
	
	// Connection Elements
	GENERIC_RELATIONSHIP ("Generic_relationship"),
	ARGUMENTATIVE_RELATIONSHIP ("Argumentative_relationship"),
	DERIVATIVE_RELATIONSHIP ("Derivative_relationship"),
	CONSEQUENCE_RELATIONSHIP ("Consequence_relationship"),
	OPTION_RELATIONSHIP ("Option_relationship"),
	
	// Error found
	NULL ("null");
	
	private String type;	
	public static List<Binding> bindings;	
	private static String NO_TYPE = EMetaModelTypes.NULL.getType();
	
	EMetaModelTypes(String type) {
		this.type = type;
	}
	
	public static String getNoType() {
		return NO_TYPE;
	}
	
	public static String toString(EMetaModelTypes cl) {		
		return cl.getType();
	}
	
	public static EMetaModelTypes getMetaModelClass(String cl) {
		
		EMetaModelTypes type = EMetaModelTypes.valueOf(cl);
		
		if (type != null) 
			return type;
		return NULL;

	}
	
	/**
	 * To be honest, I dont know anymore what this function is used for or what is does.
	 * 
	 * Returns the name of property if the object has one of the features above.
	 * Otherwise returns NULL.
	 * This is not to be changed!
	 * 
	 * @param obj
	 * @return
	 */
	public static String hasAnyProperty(EObject obj) {		
		EMetaModelTypes[] classes = EMetaModelTypes.values();
		for (int i = 0; i < classes.length; i++) {			
			EMetaModelTypes metaModelClass = classes[i];
			String metaModelClassName = metaModelClass.toString();
			if (AttributeManager.objectHasProperty(obj, metaModelClass.toString())) {
				return metaModelClassName;
			};
		}
		return NO_TYPE;		
	}	

	
	public boolean isStructural() {
		switch(this) {
		case DROBJECT:
			return true;
		case STATEMENT:
			return true;
		case DECISION_PROBLEM_OR_RESULT:
			return true;
		case DECISION_PROBLEM:
			return true;
		case DECISION_RESULT:
			return true;
		case DECISION_OPTION:
			return true;
		default:
			return false;
		}
	}
	
	/**
	 * This function could result in issues, if the meta model is changed.
	 */
	public boolean isConnection() {
		return !isStructural();
	}
	
	public String getType() {
		return this.type;
	}
	
}
