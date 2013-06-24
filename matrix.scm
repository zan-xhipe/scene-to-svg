(define (make-matrix rows columns . value)
  (do ((matrix (make-vector rows)) (i 0 ( + i 1)))
      ((= i rows) matrix)
    (vector-set! matrix i
		 (make-vector columns (if (null? value)
					  #f
					  (car value))))))

(define (matrix? matrix)
  (and (vector? matrix)
       (> (vector-length matrix) 0)
       (vector? (vector-ref matrix 0))))

(define (matrix-rows matrix)
  (vector-length matrix))

(define (matrix-columns matrix)
  (vector-length (vector-ref matrix 0)))

(define (matrix-ref matrix i j)
  (vector-ref (vector-ref matrix i) j))

(define (matrix-set! matrix i j value)
  (vector-set! (vector-ref matrix i) j value))
