#! /usr/bin/guile -s
!#

(use-modules (ice-9 getopt-long))
(use-modules (sxml simple))
(use-modules (ice-9 format))
(load "matrix.scm")

(define option-spec
  '((output (single-char #\o) (value #t))
    (help (single-char #\h) (value #f))))

(define options (getopt-long (command-line) option-spec))

(define *output-file* (option-ref options 'output #f))
(define *input-file* (car (option-ref options '() #f)))

(define *input* (with-input-from-file *input-file*
  (lambda ()
     (read))))

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

(define (svg-polygon points style)
  (list 'polygon
	(list '@
	 (list 'points
	       (points->string points))
	 (list 'style
	       style))))

(define (points->string points)
  (string-trim-right
   (format #f "~{~A ~}"
	   (map (lambda (x)
		  (point->string x)) points))))

(define (point->string point)
  (format #f "~A,~A" (car point) (cadr point)))

(define (polygons->svg _width _height points)
  (svg width _width height _height
       (map (lambda (x)
	      (svg-polygon (car x) (cadr x))) points)))

(with-output-to-file *output-file*
  (lambda ()
    (sxml->xml
     (polygons->svg 1000 1000
		    *input*))))

(define (orthographic-y point)
  (list (x point) (z point)))

;; (project (1 2 3)) => (1 3)

(write *input-file*)
(newline)
(write *input*)
(newline)
(write (make-matrix 3 3))
(newline)
 
