Class {
	#name : #StringInterpolationPlugin,
	#superclass : #OCCompilerASTPlugin,
	#category : #StringInterpolation
}

{ #category : #api }
StringInterpolationPlugin class >> interpolate: aString withAssociations: aCollection [
	| sortedValues |

	sortedValues := aCollection sorted: [ :a :b | a key x < b key x ].

	^ aString class new: aString size streamContents: [ :result | 
		  | stream range replacement |

		  stream := aString readStream.
		  [ stream atEnd ] whileFalse: [ 
			  sortedValues do: [ :aPair | 
				  range := aPair key.
				  replacement := aPair value asString.
				  range x > stream position ifTrue: [ 
					  result nextPutAll: (stream next: range x - stream position) ].
				  result nextPutAll: replacement.
				  stream next: range y - range x ] ] ]
]

{ #category : #private }
StringInterpolationPlugin class >> priority [
	^ 0
]

{ #category : #transforming }
StringInterpolationPlugin >> expandStringLiteral: aRBLiteralValueNode [ 
	
	| newMessageNode |
	(self hasInterpolationPattern: aRBLiteralValueNode value)
		ifFalse: [ ^ self ].

	newMessageNode := 	RBMessageNode
		receiver: (RBVariableNode named: self class name)
		selector: #interpolate:withAssociations:
		arguments: {
			RBLiteralValueNode value: aRBLiteralValueNode value.
			RBArrayNode statements: (self extractStatementsFrom: aRBLiteralValueNode)}.
	aRBLiteralValueNode replaceWith: newMessageNode.
	
]

{ #category : #extracting }
StringInterpolationPlugin >> extractStatementsFrom: aLiteralValueNode [
	"Parses a string inside a literalValueNode and returns a collection of Message sends.
	The receiver of each message send is a string, with the same value as the interpolation pattern.
	The selector is #-> to create an association.
	The argument is an expression to evaluate to a value in the method."

	| messages stream |

	messages := OrderedCollection new.

	stream := aLiteralValueNode value readStream.
	[ stream atEnd ] whileFalse: [ 
		| currentToken |

		currentToken := stream next.

		(currentToken == $\ and: [ 
			 stream position > 1 and: [ (stream peekBack: 2) first == $\ ] ])
			ifFalse: [ 
				(stream atEnd not and: [ stream peek == $[ ]) ifTrue: [ 
					(self nextNodeInStream: stream ofNode: aLiteralValueNode) 
						ifNotNil: [ :aNode | messages add: aNode ] ] ] ].

	^ messages
]

{ #category : #testing }
StringInterpolationPlugin >> hasInterpolationPattern: aString [ 
	
	"Any string with \[ and ] in it is a potential interpolation target"
	^ aString matchesRegex: '^.*\\\[.*\].*$'
]

{ #category : #scanning }
StringInterpolationPlugin >> nextNodeInStream: stream ofNode: aLiteralValueNode [
	| expression expressionPosition blockNode messages |

	messages := OrderedCollection new.
	expressionPosition := stream position.
	expression := stream upTo: $].
	expression := expression , { stream peekBack }.
	blockNode := nil.
	[ 
	[ blockNode := RBParser parseExpression: expression ]
		on: SyntaxErrorNotification
		do: [ :error | 
			stream atEnd
				ifTrue: [ 
					SyntaxErrorNotification
						inClass: Object
						withCode: ast sourceCode
						doitFlag: error doitFlag
						errorMessage: 'Invalid syntax in pattern'
						location: expressionPosition + aLiteralValueNode start + 1 ]
				ifFalse: [ 
				expression := expression , (stream upTo: $]) , { stream peekBack } ] ] ] 
		doWhileTrue: [ 
		blockNode isNil or: [ blockNode isBlock not ] ].
	
	^ RBMessageNode
		receiver: (RBMessageNode
				 receiver: (RBLiteralNode value: expressionPosition - 1)
				 selector: #@
				 arguments: { (RBLiteralNode value: stream position) })
		selector: #->
		arguments: { (RBMessageNode receiver: blockNode selector: #value) }
]

{ #category : #api }
StringInterpolationPlugin >> transform [
	ast nodesDo: [ :each |
		(each isLiteralNode and: [ each value isString ])
			ifTrue: [ self expandStringLiteral: each ]  ].
	^ ast doSemanticAnalysis; yourself
]
