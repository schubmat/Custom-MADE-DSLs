# Verification

## Term
Verification is the process of checking the correctness of something. In the case of Software Engineering, one checks, whether a realisation matches a specification.

## Verifying an Xtext DSL
Xtext supports two different kinds of verification methods.

1. Syntactical Verification
2. Test Verification

## Syntactical Verification
Syntactical Verification is supposed to check if the given input is well-formed. I.e. if the input corresponds to the given syntax. This is automatically done by Xtext. The language engineer does not have to take of it. Even though, should errors or warnings appear, they can be read out by the following two lines of code:

    org.eclipse.emf.ecore.resource.Resource.getErrors()
    org.eclipse.emf.ecore.resource.Resource.getWarnings()

## Test Verification
In the process of engineering, it should be evaluated. This is mostly done by testing it. 

For the purpose of testing, Xtext advises to use the package `tests`. It needs to be included in the root Gradle project in the `settings.gradle`. This could look somethings like this:

    include 'org.xtext.example.mydsl'
    include 'org.xtext.example.mydsl.ide'
    include 'org.xtext.example.mydsl.websockets'
    include 'org.xtext.example.mydsl.tests'
    rootProject.name = 'simple_decision_record_language'

`tests` is a gradle subproject, which can be created right when creating an Xtext project. It needs only little configuration, e.g. the following would be enough to put up a JUnit4 testing environment:

    dependencies {
        compile project(':org.xtext.example.mydsl')
        testCompile "org.eclipse.xtext:org.eclipse.xtext.testing:${xtextVersion}"
        testCompile "junit:junit:4.12"
    }
    mainClassName = 'org.xtext.example.mydsl.tests.MyDslParsingTest'

The tests can now be programmed quite easy.

1. Create a class responsible for testing.

The class has to have the following configuration (Xtend):

    package org.xtext.example.mydsl.tests

    import com.google.inject.Inject

    import org.eclipse.xtext.testing.InjectWith
    import org.eclipse.xtext.testing.XtextRunner
    import org.eclipse.xtext.testing.util.ParseHelper

    @RunWith(XtextRunner)
    @InjectWith(MyDslInjectorProvider)
    class MyDslParsingTest{

    }

2. Add testing methods.

Testing methods only have one condition: annotate them with `@Test`. Everything else is up to the tester. In this example, a JUnit4 Test is issued.

    @Test
	def void loadValidText() {
		
		var result = parseHelper.parse(
				'''
				URL: "news.b-tu.de"
				Header: "empty"
				Article1: "Trump is not president anymore."
				Article2: "Biden is now president."
				Article1
				'''
			)		
		Assert.assertNotNull(result)
	}

This refers to the example language given in [NewsFeedLanguage.md](NewsFeedLanguage.md). It takes a verifiable input and parses it. If the parsing process fails with the value of `null`, the assertion is triggered and the test fails.

### Useful Methods
The following is list of methods which might be helpful for a tester:

1. Parsing

To parse an input within the testing framework, use the following code.

    import org.eclipse.xtext.testing.util.ParseHelper
    ...
    parseHelper.parse(
        '''
        Input to be parsed.
        '''
    )
    ...