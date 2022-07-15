Class {
	#name : #BaselineOfStringInterpolation,
	#superclass : #BaselineOf,
	#category : #BaselineOfStringInterpolation
}

{ #category : #baselines }
BaselineOfStringInterpolation >> baseline: spec [
	<baseline>
	spec for: #common do: [ 
		spec repository: 'github://grype/pharo-string-interpolation'.
		spec package: #StringInterpolation.
		spec
			package: #'StringInterpolation-Tests'
			with: [ spec requires: #( 'StringInterpolation' ) ].
		spec
			package: #'StringInterpolation-Highlighting'
			with: [ spec requires: #( 'StringInterpolation' ) ].
		spec
			package: #'StringInterpolation-Highlighting-Tests'
			with: [ spec requires: #( 'StringInterpolation-Highlighting' ) ].
		spec
			group: 'default' with: #( 'StringInterpolation' );
			group: 'tests' with: #( 'StringInterpolation-Tests' );
			group: 'highlighting'
			with: #( 'StringInterpolation-Highlighting' );
			group: 'highlighting-tests'
			with: #( 'StringInterpolation-Highlighting-Tests' ) ]
]
