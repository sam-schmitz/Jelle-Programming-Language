#lang racket

;; jelle_interp.scm
;; Scheme intepreter for Jelle

(require "testprogs.scm")


;;----------------------------------------------------------------------
;; Memory ADT

;; Memory is an association list of (id value) pairs

;; Create an empty memory
(define (make-mem) '())

;; Associate id with value in a memory
(define (mem-put mem id value)
  (if (null? mem)
      (list (list id value))
      (let ((pair (car mem))
            (rest (cdr mem))
            )
        (if (eq? id (car pair))
            (cons (list id value) rest)
            (cons pair (mem-put rest id value))))))

;; Get the value asociated with an id in memory
(define (mem-get mem id)
  (cond ((null? mem) (error "Jelle Error---Undefined variable:" id) )
        ((eq? (caar mem) id) (cadar mem))
        (else (mem-get (cdr mem) id))))

;; Example memory for testing
(define test-mem '((a 1) (b 2) (c 3)))
;;----------------------------------------------------------------------
;;; top-level function to execute a program
(define (run prog) (exec-stmts prog (make-mem)))

(define (exec-stmts stmts mem)
  (if (null? stmts)
      mem
      (exec-stmts (cdr stmts) (exec-stmt (car stmts) mem))))

(define (exec-stmt stmt mem)
  ;; Uncomment the following line for helpful debugging info
  (display stmt) (display mem) (newline)
  (cond ((eq? (car stmt) 'display) (exec-display stmt mem))
        ((eq? (cadr stmt) ':=) (exec-assign stmt mem))
        ((eq? (car stmt) 'input) (exec-inpt (cdr stmt) mem))
        ((eq? (car stmt) 'if) (exec-if stmt mem))
        ((eq? (car stmt) 'while) (exec-while stmt mem))
        (else (error "Jelle Error---Bad Statement:" stmt))))

(define (exec-display stmt mem)
  (define (arg->displayable arg)
    (cond ((string? arg) arg)
          ((eq? arg 'nl) "\n")
          (else (eval-expr arg mem))))

  (define (display-loop args)
    (if (null? args)
        mem ;; result of exec-display is just original memory
        (begin
          (display (arg->displayable (car args)))
          (display-loop (cdr args)))))
  
  (display-loop (cdr stmt)))


(define (exec-assign stmt mem);executes an assignment statement
  (mem-put mem (car stmt) (eval-expr (caddr stmt) mem)))

(define (exec-inpt stmt mem);executes an input statement
  (if (> (length stmt) 1)
      (exec-inpt (cdr stmt) (mem-put mem (car stmt) (string->number (read-line))))
      (mem-put mem (car stmt) (string->number (read-line)))))

(define (exec-if stmt mem);executes an if statement
  ;remove the comments on the following line for debugging info
  ;(display (simp-cond (cadr stmt) mem)) (newline)
  (if (eval (simp-cond (cadr stmt) mem));evaluate the statement
      (exec-stmts (caddr stmt) mem)
      (cond ((> (length stmt) 3) (exec-stmts (cdddr stmt) mem))
            ((eq? (length stmt) 3) (mem))
            (else (error "bad if statement")))))

(define (exec-while stmt mem);executes while statements
  ; uncomment the following line for helpful debugging info
  (display (simp-cond (cadr stmt) mem)) (display (cadr stmt)) (newline)
  (if (eval (simp-cond (cadr stmt) mem));check that the conditions are met
      (exec-while stmt (exec-stmts (cddr stmt) mem));when conditions are met execute and recurse until they are not
      mem));when conditions are not met return the mem

(define (simp-cond stmt mem);returns a condition statement with any variables retruned as numbers
  (list (car stmt) (eval-expr (cadr stmt) mem) (eval-expr (caddr stmt) mem)))

(define (eval-expr expr mem);evaluates expressions
  (cond ((number? expr) expr);if it is a number return that
        ((list? expr) (cond   ;if a list than do equation
                      ((eq? (car expr) '+) (eval-add (cdr expr) mem))
                      ((eq? (car expr) '-) (eval-sub (cdr expr) mem))
                      ((eq? (car expr) '*) (eval-mul (cdr expr) mem))
                      ((eq? (car expr) '/) (eval-div (cdr expr) mem))
                      ((eq? (car expr) '^) (eval-exp (cdr expr) mem))
                      ((eq? (car expr) '%) (eval-mod (cdr expr) mem))
                      ((eq? (length expr) 2) (eval-neg (cdr expr) mem))
                      (else (error "Unimplemented expression type" expr))))
              (else (mem-get mem expr))))

(define (eval-neg args mem)
  (apply * (list (eval-expr (car args) mem) -1)))

(define (eval-add args mem);evaluates adition action
  (apply + (list (eval-expr (car args) mem) (eval-expr (cadr args) mem))))

(define (eval-sub args mem);executes a sibtraction action
  (apply - (list (eval-expr (car args) mem) (eval-expr (cadr args) mem))))

(define (eval-mul args mem)
  (apply * (list (eval-expr (car args) mem) (eval-expr (cadr args) mem))))

(define (eval-div args mem)
  (apply / (list (eval-expr (car args) mem) (eval-expr (cadr args) mem))))

(define (eval-exp args mem)
  (apply expt (list (eval-expr (car args) mem) (eval-expr (cadr args) mem))))

(define (eval-mod args mem)
  (apply modulo (list (eval-expr (car args) mem) (eval-expr (cadr args) mem))))