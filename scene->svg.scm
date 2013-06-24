#! /usr/bin/guile -s
!#

(use-modules (ice-9 getopt-long))
(use-modules (sxml simple))

(define option-spec
  '((output (single-char #\o) (value #t))
    (help (single-char #\h) (value #f))))

(define options (getopt-long (command-line) option-spec))

(define output-file (option-ref options 'output #f))

(define test-svg '(*TOP* (svg (@ (xmlns "http://www.w3.org/2000/svg")
				 (version "1.1"))
			      (rect (@ (width 300)
				       (height 100)
				       (style "fill:rgb(0,0,255);stroke-width:1;stroke:rgb(0,0,0)")))
			
)))

(with-output-to-file output-file
  (lambda ()
    (sxml->xml test-svg)))
