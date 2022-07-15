Class {
	#name : #StringInterpolationASTStructureTest,
	#superclass : #TestCase,
	#instVars : [
		'ast',
		'sourceCode'
	],
	#category : #'StringInterpolation-Highlighting-Tests'
}

{ #category : #tests }
StringInterpolationASTStructureTest >> interpolationNode [

	^ ast statements first
]

{ #category : #tests }
StringInterpolationASTStructureTest >> testASTHasStringInterpolationNode [
	
	self assert: ast statements first isStringInterpolationNode
]

{ #category : #tests }
StringInterpolationASTStructureTest >> testInterpolatedMessageStartCorrespondsToExpressionStartInString [

	| message |
	message := self interpolationNode patterns anyOne.
	self assert: message start equals: (sourceCode indexOf: ${) + 1
]

{ #category : #tests }
StringInterpolationASTStructureTest >> testInterpolationNodeHasMessageSend [
	
	self assert: self interpolationNode patterns anyOne isMessage
]
