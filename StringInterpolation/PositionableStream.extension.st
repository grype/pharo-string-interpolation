Extension { #name : #PositionableStream }

{ #category : #'*StringInterpolation' }
PositionableStream >> back: anInt [
	"Go back one element and return it."

	self position < anInt ifTrue: [self positionError].
	self skip: 0-anInt.
	^ self peek: anInt
]

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

{ #category : #'*StringInterpolation' }
PositionableStream >> peekBack: anInt [
	"Return the element at the previous position, without changing position.  Use indirect messages in case self is a StandardFileStream."

	| elements |
	elements := self back: anInt.
	self skip: anInt.
	^ elements
]
