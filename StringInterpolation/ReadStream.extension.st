Extension { #name : #ReadStream }

{ #category : #'*StringInterpolation' }
ReadStream >> upToNextMatching: anObject [
	"fast version using indexOf:"

	| start end count currentObject |

	start := position + 1.
	end := 0.
	count := 1.
	currentObject := self peek.
	[ 
	end := collection
		       indexOfAnyOf: { 
				       anObject.
				       currentObject }
		       startingAt: position + 1
		       ifAbsent: [ 0 ] ] doWhileTrue: [ 
		count := (end = 0 or: [(collection at: end) = anObject])
			         ifTrue: [ count - 1 ]
			         ifFalse: [ count + 1 ].
		position := end.
		end ~= 0 and: [ self atEnd not and: [ count > 0 ] ] ].

	"not present--return rest of the collection"
	(end = 0 or: [ end > readLimit ]) ifTrue: [ ^ self upToEnd ].

	"skip to the end and return the data passed over"
	position := end.
	^ collection copyFrom: start to: end - 1
]
