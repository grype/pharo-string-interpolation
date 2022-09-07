Extension { #name : #PositionableStream }

{ #category : #'*StringInterpolation' }
PositionableStream >> peek: anInt [
	"Answer what would be returned if the message next were sent to the 
	receiver. If the receiver is at the end, answer nil."

	| nextObject |
	self atEnd ifTrue: [^nil].
	nextObject := self next: anInt.
	position := position - anInt.
	^nextObject
]
