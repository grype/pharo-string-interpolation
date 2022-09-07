"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestStringInterpolation,
	#superclass : #PackageManifest,
	#category : #'StringInterpolation-Manifest'
}

{ #category : #'code-critics' }
ManifestStringInterpolation class >> ruleBadMessageRule2V1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#StringInterpolationPlugin #extractStatementsFrom: #false)) #'2022-09-06T22:09:42.768871-07:00') )
]

{ #category : #'code-critics' }
ManifestStringInterpolation class >> ruleLiteralArrayContainsSuspiciousTrueFalseOrNilRuleV1FalsePositive [
	^ #(#(#(#RGPackageDefinition #(#StringInterpolation)) #'2022-09-06T22:11:52.63183-07:00') )
]

{ #category : #'code-critics' }
ManifestStringInterpolation class >> ruleLongMethodsRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#ReadStream #upToNextMatching: #false)) #'2022-09-06T22:09:19.927939-07:00') #(#(#RGMethodDefinition #(#StringInterpolationPlugin #extractStatementsFrom: #false)) #'2022-09-06T22:09:34.958401-07:00') )
]

{ #category : #'code-critics' }
ManifestStringInterpolation class >> ruleUtilityMethodsRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#StringInterpolationPlugin #extractStatementsFrom: #false)) #'2022-09-06T22:09:38.759408-07:00') #(#(#RGMethodDefinition #(#StringInterpolationPlugin #hasInterpolationPattern: #false)) #'2022-09-06T22:09:52.075742-07:00') )
]
