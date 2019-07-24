;
; always.scm
;
; Basic unit test for AlwaysLink
; This is (soon will be) example code.
; Invented after discussions at opencog/atomspace#2203
;

(use-modules (opencog) (opencog exec))

; Three baskets holding balls
(Inheritance (Concept "reds basket") (Concept "basket"))
(Inheritance (Concept "reds&greens basket") (Concept "basket"))
(Inheritance (Concept "yellows basket") (Concept "basket"))

; Balls placed into baskets
(Member (Concept "red ball") (Concept "reds basket"))
(Member (Concept "red ball too") (Concept "reds basket"))
(Member (Concept "red ball also") (Concept "reds basket"))
(Member (Concept "red ball") (Concept "reds&greens basket"))
(Member (Concept "red ball too") (Concept "reds&greens basket"))
(Member (Concept "green ball") (Concept "reds&greens basket"))
(Member (Concept "yellow ball") (Concept "yellows basket"))

; Colors of the balls
(Evaluation (Predicate "is red") (Concept "red ball"))
(Evaluation (Predicate "is red") (Concept "red ball too"))
(Evaluation (Predicate "is red") (Concept "red ball also"))

(Evaluation (Predicate "is green") (Concept "green ball"))
(Evaluation (Predicate "is yellow") (Concept "yellow ball"))

(define baskets-with-red-balls-only
	(Bind
		(VariableList
			(TypedVariable (Variable "basket") (Type 'ConceptNode))
			(TypedVariable (Variable "ball") (Type 'ConceptNode))
		)
		(And
			(Inheritance (Variable "basket") (Concept "basket"))
			(Member (Variable "ball") (Variable "basket"))

			; Always means that *every* ball in the basket MUST
			; be red! Failure to satisfy this invalidates the
			; search.
			(Always (Evaluation (Predicate "is red")  (Variable "ball")))
		)

		; Report the basket which has only red balls in it.
		(Variable "basket"))
)
