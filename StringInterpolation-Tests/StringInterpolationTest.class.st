Class {
	#name : #StringInterpolationTest,
	#superclass : #TestCase,
	#category : #'StringInterpolation-Tests'
}

{ #category : #compiler }
StringInterpolationTest class >> compiler [
	^ super compiler
		  addPlugin: StringInterpolationPlugin;
		  yourself
]

{ #category : #compiler }
StringInterpolationTest class >> highlighter [

	^super highlighter
		addPlugin: StringInterpolationASTHighlighterPlugin
]

{ #category : #compiler }
StringInterpolationTest class >> recompileAllTestMethods [
	<script>
	self methods
		select: [ :meth | meth selector beginsWith: 'test' ]
		thenDo: [ :meth | meth recompile ]
]

{ #category : #tests }
StringInterpolationTest >> testEscapedExpression [
	self assert: '1+2 is \\[1 + 2]' equals: '1+2 is \\' , '[1 + 2]'.
	self assert: '1+2 is \\\[1 + 2]' equals: '1+2 is \\\' , '[1 + 2]'
]

{ #category : #tests }
StringInterpolationTest >> testExpressionRaisingExceptionFailsAtRuntime [
	| ok |

	ok := false.
	[ '\[self error: ''example error'']' ]
		on: Error
		do: [ :error | ok := error messageText = 'example error' ].
	self assert: ok equals: true
]

{ #category : #tests }
StringInterpolationTest >> testHasInterpolationPatternInEscapedForm [
	self deny:
		(StringInterpolationPlugin hasInterpolationPattern:
			 '1+2 is \\[1 + 2]').
	self deny:
		(StringInterpolationPlugin hasInterpolationPattern:
			 '1+2 is \\\[1 + 2]').
]

{ #category : #tests }
StringInterpolationTest >> testHasInterpolationPatternInUnescapedForm [
	self
		assert:
		(StringInterpolationPlugin hasInterpolationPattern:
			 '1+2 is \[1 + 2]')
		equals: true
]

{ #category : #tests }
StringInterpolationTest >> testInterpolateExpression [

	self assert: '1+1 is \[1 + 1]' equals: '1+1 is 2'
]

{ #category : #tests }
StringInterpolationTest >> testInterpolateExpressionCallsAsString [

	self assert: 'self asString is \[self asString]' equals: 'self asString is ', self asString
]

{ #category : #tests }
StringInterpolationTest >> testInterpolateExpressionMixingContextWithConstants [

	| variable |
	variable := 2.
	self assert: '1 + variable is \[1 + variable]' equals: '1 + variable is 3'
]

{ #category : #tests }
StringInterpolationTest >> testInterpolateFailingExpressionThrowsSyntaxError [
	self
		should: [ self class compiler evaluate: '''1+1 is \' , '[1*]''' ]
		raise: SyntaxErrorNotification
]

{ #category : #tests }
StringInterpolationTest >> testInterpolateStringSyntaxErrorHasStartAtTheBeginningOfTheFailingExpression [
	| ok str |

	ok := false.
	str := '''1+1 is \' , '[1*]'''.
	[ self class compiler evaluate: str ]
		on: SyntaxErrorNotification
		do: [ :err | ok := err location = ((str indexOf: $\) + 1) ]. "+1 to account leading quote."
	self assert: ok equals: true
]

{ #category : #tests }
StringInterpolationTest >> testInterpolateVariable [

	| variable |
	variable := 2.
	self assert: '1+1 is \[variable]' equals: '1+1 is 2'
]

{ #category : #tests }
StringInterpolationTest >> testWithFormat [
	self
		assert: ('{1} + {2} is \[1 + 2]' format: { 1. 2 })
		equals: '1 + 2 is 3'
]
