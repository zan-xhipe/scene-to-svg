#! /usr/bin/guile -s
!#

(use-modules (ice-9 getopt-long))
(use-modules (sxml simple))
(use-modules (ice-9 format))

(define option-spec
  '((output (single-char #\o) (value #t))
    (help (single-char #\h) (value #f))))

(define options (getopt-long (command-line) option-spec))

(define output-file (option-ref options 'output #f))

(define-syntax svg
  (syntax-rules (params width height)
    ((svg params para body ...)
     (list '*TOP*
	   (list 'svg
		 para
		 body ...)))
    ((svg width w height h body ...)
     (svg params `(@ (xmlns "http://www.w3.org/2000/svg")
		     (version "1.1")
		     (width ,w)
		     (height ,h))
	  body ...))
    ((svg body ...)
     (svg params '(@ (xmlns "http://www.w3.org/2000/svg")
		     (version "1.1"))
	  body ...))))

(define (point->string point)
  (format #f "~A,~A" (car point) (cadr point)))

(define (points->string points)
  (string-trim-right
   (format #f "~{~A ~}"
	   (map (lambda (x)
		  (point->string x)) points))))

(define (svg-polygon points style)
  (list 'polygon
	(list '@
	 (list 'points
	       (points->string points))
	 (list 'style
	       style))))


(with-output-to-file output-file
  (lambda ()
    (sxml->xml (svg width 1000 height 1000
		(svg-polygon '((100 10) (250 190) (160 210))
			     "fill:red;stroke:purple;stroke-width:1")
		(svg-polygon '((200 10) (250 190) (160 210))
			     "fill:lime;stroke:purple;stroke-width:1")))))

(write (points->string '((0 0) (1 1) (2 2))))
(newline)

