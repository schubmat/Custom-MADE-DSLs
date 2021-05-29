/*
 * generated by Xtext unknown
 */
package org.xtext.example.mydsl.tests

import com.google.inject.Inject
import java.util.logging.Logger;

import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.eclipse.xtext.testing.util.ParseHelper
import org.junit.Assert
import org.junit.Test
import org.junit.runner.RunWith
import org.xtext.example.mydsl.myDsl.Model
import java.util.logging.Level
import java.io.File
import java.io.IOException
import java.io.FileWriter

@RunWith(XtextRunner)
@InjectWith(MyDslInjectorProvider)
class MyDslParsingTest{

	@Inject
	ParseHelper<Model> parseHelper

	// Unit Test 1: Unverifiable Input

	@Test 
	def void loadWrongText() {
	
		var Model result 
		try {			
			result = parseHelper.parse('''This should not be here!''')
		} catch (Exception e) {
			result = null
		}
		try {
			val headerContent = result.website.url.name
		} catch (NullPointerException e) {
			result = null
		}
		Assert.assertNull(result)
	} 

	// Unit Test 2: Verifiable Input

	@Test
	def void loadValidText() {
		
		var result = parseHelper.parse(
				'''
				URL: "news.b-tu.de"
				Header: "empty"
				Article1: "Trump is not president anymore."
				Article2: "Biden is now president"
				Article1
				'''
			)		
		Assert.assertNotNull(result)
	}
	
	def static void writeToFile(String text) {
	    try {
	      val myWriter = new FileWriter("/home/robert/SWT-Praktikum/Log.log");
	      myWriter.write(text);
	      myWriter.close();
	    } catch (IOException e) {
	      e.printStackTrace();
	    }
	}

}