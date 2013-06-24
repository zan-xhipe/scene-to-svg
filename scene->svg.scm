#! /usr/bin/guile -s
!#

(use-modules (ice-9 getopt-long))

(define option-spec
  '((output (single-char #\o) (value #t))
    (help (single-char #\h) (value #f))))

(define options (getopt-long (command-line) option-spec))

(write (option-ref options 'output #f))
(newline)
