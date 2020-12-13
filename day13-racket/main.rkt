#lang racket

(require (only-in math/number-theory solve-chinese))
 
(define (parse-schedule str)
  (map string->number (string-split str ",")))

(define-values (timestamp ids)
  (call-with-input-file "input.txt"
    (lambda (in)
      (values
      (string->number (read-line in))
      (parse-schedule (read-line in))))))


;;; Part 1
(define (calc-wait to from)
  (- from (remainder to from)))

(define calc-waits (for/list ([id (in-list ids)]
    #:when id)
  (list id (calc-wait timestamp id))))

(apply * (argmin cadr calc-waits))

;;; Part 2
(define active-buses (for/list ([id (in-list ids)] #:when id) id))

(define times (for/list ([id (in-list ids)] [i (in-naturals)] #:when id) (- i)))

(solve-chinese times active-buses)
