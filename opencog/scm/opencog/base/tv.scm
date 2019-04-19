;
; tv.scm
;
; Useful utilities for working with truth values.
;
; Utilities provided:
; -- cog-merge-tv! -- merge truth values on atom
; -- cog-merge-hi-conf-tv! -- different merge style
; -- cog-stv-strength -- SimpleTruthValue strength of an atom
; -- cog-stv-strength-above -- Filter atoms with TV strength above a threshold
; -- cog-stv-strength-below -- Filter atoms with TV strength below a threshold
; -- cog-stv-confidence -- TruthValue confidence of an atom
; -- cog-stv-confidence-above -- Filter atoms with TV confidence above a threshold
; -- cog-stv-confidence-below -- Filter atoms with TV confidence below a threshold
; -- cog-stv-count -- TruthValue count of an atom
; -- cog-stv-count-above -- Filter atoms with TV count above a threshold
; -- cog-stv-count-below -- Filter atoms with TV count below a threshold
; -- cog-stv-positive-filter -- Filter atoms with positive TV strength and count
;
;
; Copyright (c) 2014 Cosmo Harrigan
;

; ===================================================================

; Fetch the mean, confidence and count of a TV.
(define-public (tv-mean TV)
"
  Warning: this function is obsolete, use cog-tv-mean instead

  Return the floating-point mean (strength) of a TruthValue.
  Deprecated; use cog-tv-mean instead.
"
	(cog-tv-mean TV)
)

(define-public (tv-conf TV)
"
  Warning: this function is obsolete, use cog-tv-confidence instead

  Return the floating-point confidence of a TruthValue.
  Deprecated; use cog-tv-confidence instead.
"
	(cog-tv-confidence TV)
)

(define-public (tv-non-null-conf? TV)
"
  Return #t if the confidence of tv is positive, #f otherwise.
  Deprecated. Just say (< 0 (cog-tv-confidence TV)) instead.
"
	(< 0 (cog-tv-confidence TV))
)

;
; Simple truth values won't have a count. Its faster to just check
; for #f than to call (cog-ctv? tv)
(define-public (tv-count TV)
"
  Warning: this function is obsolete, use cog-tv-count instead

  Return the floating-point count of a CountTruthValue.
  Deprecated; use cog-tv-count instead.
"
	(cog-tv-count TV)
)

(define-public (tv-positive-count TV)
"
  Return the floating-point positive count of a EvidenceCountTruthValue.
"
	(define pos-cnt (assoc-ref (cog-tv->alist TV) 'positive-count))
	(if (eq? pos-cnt #f) 0 pos-cnt)
)

; ===================================================================
; Simple wrappers for TruthValues

(define-public (cog-new-stv MEAN CONFIDENCE)
"
 cog-new-stv MEAN CONFIDENCE
    Create a SimpleTruthValue with the given MEAN and CONFIDENCE.
    Equivalent to (cog-new-value 'SimpleTruthValue MEAN CONFIDENCE)

    Unlike Atoms, Values are ephemeral: they are automatically
    garbage-collected when no longer needed.

    Throws error if MEAN and CONFIDENCE are not numeric values.
    Example:
        ; Create a new simple truth value:
        guile> (cog-new-stv 0.7 0.9)
"
	(cog-new-value 'SimpleTruthValue MEAN CONFIDENCE)
)

(define-public (cog-new-ctv MEAN CONFIDENCE COUNT)
"
 cog-new-ctv MEAN CONFIDENCE COUNT
    Create a CountTruthValue with the given MEAN, CONFIDENCE and COUNT.
    Equivalent to
    (cog-new-value 'CountTruthValue MEAN CONFIDENCE COUNT)

    Unlike Atoms, Values are ephemeral: they are automatically
    garbage-collected when no longer needed.

    Throws error if MEAN, CONFIDENCE and COUNT are not numeric values.
    Example:
        ; Create a new count truth value:
        guile> (cog-new-ctv 0.7 0.9 44.0)
"
	(cog-new-value 'CountTruthValue MEAN CONFIDENCE COUNT)
)

(define-public (cog-new-itv LOWER UPPER CONFIDENCE)
"
 cog-new-itv LOWER UPPER CONFIDENCE
    Create an IndefiniteTruthValue with the given LOWER, UPPER and
    CONFIDENCE.  Equivalent to
    (cog-new-value 'IndefiniteTruthValue LOWER UPPER CONFIDENCE)

    Unlike Atoms, Values are ephemeral: they are automatically
    garbage-collected when no longer needed.

    Throws error if LOWER, UPPER and CONFIDENCE are not numeric values.
    Example:
        ; Create a new indefinite truth value:
        guile> (cog-new-itv 0.7 0.9 0.6)
"
	(cog-new-value 'IndefiniteTruthValue LOWER UPPER CONFIDENCE)
)

(define-public (cog-new-etv POSITIVE-COUNT TOTAL-COUNT)
"
 cog-new-etv POSITIVE-COUNT TOTAL-COUNT
    Create an EvidenceCountTruthValue with the given POSITIVE-COUNT
    and TOTAL-COUNT. Equivalent to
    (cog-new-value 'EvidenceCountTruthValue POSITIVE-COUNT TOTAL-COUNT)

    Unlike Atoms, Values are ephemeral: they are automatically
    garbage-collected when no longer needed.

    The total count is optional in the sense that any value below the
    positive count will be considered undefined.

    Throws error if positive-count and total-count are not numeric
    values.
    Example:
        ; Create a new simple truth value:
        guile> (cog-new-etv 100 150)
"
	(cog-new-value 'EvidenceCountTruthValue POSITIVE-COUNT TOTAL-COUNT)
)

(define-public (cog-new-ftv MEAN CONFIDENCE)
"
 cog-new-ftv MEAN CONFIDENCE
    Create a FuzzyTruthValue with the given MEAN and CONFIDENCE.
    Equivalent to (cog-new-value 'FuzzyTruthValue MEAN CONFIENCE)

    Unlike Atoms, Values are ephemeral: they are automatically
    garbage-collected when no longer needed.

    Throws error if MEAN or CONFIDENCE are not numeric values.
    Example:
        ; Create a new fuzzy truth value:
        guile> (cog-new-ftv 0.7 0.9)
"
	(cog-new-value 'FuzzyTruthValue MEAN CONFIDENCE)
)

(define-public (cog-new-ptv MEAN CONFIDENCE COUNT)
"
 cog-new-ptv MEAN CONFIENCE COUNT
    Create a ProbabilisticTruthValue with the given MEAN, CONFIDENCE
    and COUNT.  Equivalent to
    (cog-new-value 'ProbabilisticTruthValue MEAN CONFIENCE COUNT)

    Unlike Atoms, Values are ephemeral: they are automatically
    garbage-collected when no longer needed.

    Throws errors if MEAN, CONFIDENCE and COUNT are not numeric values.
    Example:
        ; Create a new probabilistic truth value:
        guile> (cog-new-ptv 0.7 0.9 44.0)
"
	(cog-new-value 'ProbabilisticTruthValue MEAN CONFIDENCE COUNT)
)

(define-public (stv mean conf) (cog-new-stv mean conf))
(define-public (ctv mean conf count) (cog-new-ctv mean conf count))
(define-public (itv lower upper conf) (cog-new-itv lower upper conf))
(define-public (etv pos-count total-count) (cog-new-etv pos-count total-count))
(define-public (ftv mean conf) (cog-new-ftv mean conf))
(define-public (ptv mean conf count) (cog-new-ptv mean conf count))

; ===================================================================

(define-public (cog-tv? EXP)
"
 cog-tv? EXP
    Return #t if EXP is a TruthValue, else return #f
    Equivalent to (cog-subtype? 'TruthValue (cog-type EXP))

    Example:
       ; Define a simple truth value
       guile> (define x (cog-new-stv 0.7 0.9))
       guile> (define y (+ 2 2))
       guile> (cog-tv? x)
       #t
       guile> (cog-tv? y)
       #f
"
	(cog-subtype? 'TruthValue (cog-type EXP))
)

(define-public (cog-stv? EXP)
"
 cog-stv? EXP
    Return #t if EXP is a SimpleTruthValue, else return #f.
    Equivalent to (equal? 'SimpleTruthValue (cog-type EXP))
"
	(equal? 'SimpleTruthValue (cog-type EXP))
)

(define-public (cog-ctv? EXP)
"
 cog-ctv? EXP
    Return #t if EXP is a CountTruthValue, else return #f.
    Equivalent to (equal? 'CountTruthValue (cog-type EXP))
"
	(equal? 'CountTruthValue (cog-type EXP))
)

(define-public (cog-itv? EXP)
"
 cog-itv? EXP
    Return #t if EXP is a IndefiniteTruthValue, else return #f.
    Equivalent to (equal? 'IndefiniteTruthValue (cog-type EXP))
"
	(equal? 'IndefiniteTruthValue (cog-type EXP))
)

(define-public (cog-ptv? EXP)
"
 cog-ptv? EXP
    Return #t if EXP is a ProbablisticTruthValue, else return #f.
    Equivalent to (equal? 'ProbabilisticTruthValue (cog-type EXP))
"
	(equal? 'ProbabilisticTruthValue (cog-type EXP))
)

(define-public (cog-ftv? EXP)
"
 cog-ftv? EXP
    Return #t if EXP is a FuzzyTruthValue, else return #f.
    Equivalent to (equal? 'FuzzyTruthValue (cog-type EXP))
"
	(equal? 'FuzzyTruthValue (cog-type EXP))
)

; ===================================================================
; -----------------------------------------------------------------------
(define-public (cog-merge-tv! ATOM TV)
" cog-merge-tv! -- merge truth values on atom"
	(cog-set-tv! ATOM (cog-tv-merge (cog-tv ATOM) TV))
)

; -----------------------------------------------------------------------
(define-public (cog-merge-hi-conf-tv! ATOM TV)
" cog-merge-hi-conf-tv! -- merge truth values on atom"
	(cog-set-tv! ATOM (cog-tv-merge-hi-conf (cog-tv ATOM) TV))
)

; -----------------------------------------------------------------------
(define-public (cog-stv-strength x)
"
  cog-stv-strength
  Return the truth value strength of an atom
  (Compatible with atoms that have a SimpleTruthValue)
"
	(cdr (assoc 'mean (cog-tv->alist (cog-tv x)))))

; -----------------------------------------------------------------------
(define-public (cog-stv-strength-above y z)
"
  cog-stv-strength-above
  Given a threshold 'y' and a list of atoms 'z', returns a list of atoms with
  truth value strength above the threshold
  (Compatible with atoms that have a SimpleTruthValue)
"
	(filter (lambda (x) (> (cog-stv-strength x) y)) z))

; -----------------------------------------------------------------------
(define-public (cog-stv-strength-below y z)
"
  cog-stv-strength-below
  Given a threshold 'y' and a list of atoms 'z', returns a list of atoms with
  truth value strength above the threshold
  (Compatible with atoms that have a SimpleTruthValue)
"
	(filter (lambda (x) (< (cog-stv-strength x) y)) z))

; -----------------------------------------------------------------------
(define-public (cog-stv-confidence x)
"
  cog-stv-confidence
  Return the truth value confidence of an atom
  (Compatible with atoms that have a SimpleTruthValue)
"
	(cdr (assoc 'confidence (cog-tv->alist (cog-tv x)))))

; -----------------------------------------------------------------------
(define-public (cog-stv-confidence-above y z)
"
  cog-stv-confidence-above
  Given a threshold 'y' and a list of atoms 'z', returns a list of atoms with
  truth value confidence above the threshold
  (Compatible with atoms that have a SimpleTruthValue)
"
	(filter (lambda (x) (> (cog-stv-confidence x) y)) z))

; -----------------------------------------------------------------------
(define-public (cog-stv-confidence-below y z)
"
  cog-stv-confidence-below
  Given a threshold 'y' and a list of atoms 'z', returns a list of atoms with
  truth value confidence above the threshold
  (Compatible with atoms that have a SimpleTruthValue)
"
	(filter (lambda (x) (< (cog-stv-confidence x) y)) z))

; -----------------------------------------------------------------------
(define-public (cog-stv-count x)
"
  cog-stv-count
  Return the truth value count of an atom
  (Compatible with atoms that have a SimpleTruthValue)
"
	(cdr (assoc 'count (cog-tv->alist (cog-tv x)))))

; -----------------------------------------------------------------------
(define-public (cog-stv-count-above y z)
"
  cog-stv-count-above
  Given a threshold 'y' and a list of atoms 'z', returns a list of atoms with
  truth value count above the threshold
  (Compatible with atoms that have a SimpleTruthValue)
"
	(filter (lambda (x) (> (cog-stv-count x) y)) z))

; -----------------------------------------------------------------------
(define-public (cog-stv-count-below y z)
"
  cog-stv-count-below
  Given a threshold 'y' and a list of atoms 'z', returns a list of atoms with
  truth value count above the threshold
  (Compatible with atoms that have a SimpleTruthValue)
"
	(filter (lambda (x) (< (cog-stv-count x) y)) z))

; -----------------------------------------------------------------------
(define-public (cog-stv-positive-filter x)
"
  cog-stv-positive-filter
  Given a list of atoms, returns a list containing the subset that has
  truth value count > 0 and truth value strength > 0
  (Compatible with atoms that have a SimpleTruthValue)
"
	(cog-stv-strength-above 0 (cog-stv-count-above 0 x)))
