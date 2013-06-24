#! /usr/bin/guile -s
!#

(use-modules (ice-9 getopt-long))

(define option-spec
  '((output (single-char #\o) (value #t))
    (help (single-char #\h) (value #f))))

(define options (getopt-long (command-line) option-spec))

(define output-file (option-ref options 'output #f))

(with-output-to-file output-file
  (lambda ()
    (write 'test)))
