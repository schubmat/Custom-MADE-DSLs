# News Feed Language
This is an example language, used to the purpose of showing how to use different aspects of Xtext.

## The Grammar
The grammar, as it is integrated in Xtext, is as follows:

    grammar org.xtext.example.mydsl.MyDsl with org.eclipse.xtext.common.Terminals

    import "http://www.eclipse.org/emf/2002/Ecore" as ecore
    generate myDsl "http://www.xtext.org/example/mydsl/MyDsl"

    Model: 
        website=Website
    ;

    Website: 
        url=URL
        header=Header
        feed=Feed
        articleOfTheDay=[Article]
    ;

    URL:
        "URL: " name=STRING
    ;

    Header:
        "Header: " content=STRING
    ;

    Feed:
        (articles+=Article)+
    ;

    Article:
        name=ID ": " content=STRING
    ;


## Example 1
    URL: "news.b-tu.de"
	Header: "empty"
	Article1: "Trump is not president anymore."
	Article2: "Biden is now president"
	Article1

## Example 2
    URL: "my.newsshow.com"
	Header: "English-speaking audience"
	MoreEnglishSpeakers: "More and more people speak English!"
	MoreEnglishSpeakers