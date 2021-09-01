package org.xtext.example.mydsl.ide.diagram.flexdr;

import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.beanutils.PropertyUtils;
import org.eclipse.emf.ecore.EObject;
import org.xtext.example.mydsl.ide.diagram.launch.GraphicalServerLauncher;

/**
 * 
 * @author Robert Richter
 * @date 26th April 2021
 * 
 * This class is used to retrieve specific field from an object of which
 * the attributes are not known.
 * A typical usecase is within a generic diagram generator for EMF-based
 * models.
 * 
 */
public class AttributeManager {
	
	public static Boolean objectHasProperty(EObject obj, String propertyName){
	    List<Field> properties = getAllFields(obj);
	    
	    for(Field field : properties){
	        if(field.getName().equalsIgnoreCase(propertyName)){
	            return true;
	        }
	    }
	    return false;
	}

	public static List<Field> getAllFields(EObject obj){
	    List<Field> fields = new ArrayList<Field>();
	    getAllFieldsRecursive(fields, obj.getClass());
	    return fields;
	}

	private static List<Field> getAllFieldsRecursive(List<Field> fields, Class<?> type) {
	    for (Field field: type.getDeclaredFields()) {
	        fields.add(field);
	    }

	    if (type.getSuperclass() != null) {
	        fields = getAllFieldsRecursive(fields, type.getSuperclass());
	    }

	    return fields;
	}
	
	/**
	 * Returns the value of a given field within a class or throws exception
	 * if returning the value is not possible.
	 */
	public static Object getProperty(Object obj, String fieldName) throws Exception {
		return PropertyUtils.getProperty(obj, fieldName);
	}
	
}
