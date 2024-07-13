#lang racket

(provide prog0 prog1 prog2 prog3 prog4 prog5 prog6 prog7 quad1 quad2 quad3 quad4 quad5)

(define prog0
  '(
    (display "Hello, World!" nl)
    )
  )

(define prog1
  '(
    (display 1 " = 1" nl)
    (display (+ 1 2) " = 3" nl)
    (display (^ 2 3) " = 8" nl)
    (display (% 12 5) " = 2" nl)
    )
  )

(define prog2
  '(
    (a := 1)
    (display a " = 1" nl)
    )
  )

(define prog3
  '(
    (a := 1)
    (b := 2)
    (c := 3)
    (display (+ a (* b c)) " = 7" nl)
    )
  )

(define prog4
  '(
    (display "Enter a b c: ")
    (input a b c)
    (display "a = " a nl "b = " b nl "c = " c nl)
    )
  )

(define prog5
  '(
    (a := 1)
    (b := 2)
    (c := 3)
    (if (< a b)(
        (display "a is less than b" nl)
        )
       )
    (if (> a b)(
        (display "Should not see this line!" nl)
        (display "or this line" nl)
        )
        (display "First line of else should print" nl)
        (display "So should this second line" nl)
        )
    )
  )

(define prog6
  '((display "Future Value" nl)
    (display "Enter the principal: ")
    (input principal)
    (display "Enter the apr: ")
    (input apr)
    (display "Enter number of years: ")
    (input num_years)
    
    (year := 0)
    (while (< year num_years)
           (principal := (+ principal (* principal apr)))
           (year := (+ year 1))
           (display "Year " year ": " principal nl)
    )
    (display "Have a nice day!" nl)
    ))

(define prog7
  '(
    (a := 1)
    (b := 2)
    (a := (* b 2))
    (display "a = " a)
    ))


(define quad1
  '(
     (display "Enter the value of a: ")
     (input a)
     (display "Enter the value of b: ")
     (input b)
     (display "Enter the value of c: ")
     (input c)

     (discrim := (- (^ b 2) (* (* 4 a) c)))
     (discroot := (^ discrim 0.5))

     (display "root1 is " (/ (+ (- b) discroot) (* 2 a)) nl)
     (display "root1 is " (/ (- (- b) discroot) (* 2 a)) nl)
     )
   )

(define quad2
  '(
     (display "Enter the values of  a b c: ")
     (input a b c)
     (discrim := (- (^ b 2) (* (* 4 a) c)))
     ( if (>= discrim 0)
	( (discroot := (^ discrim 0.5))
          (display "root1 is " (/ (+ (- b) discroot) (* 2 a)) nl)
          (display "root1 is " (/ (- (- b) discroot) (* 2 a)) nl)
	  )
	)
     )
   )

(define quad3
  '(
     (display "Enter the values of  a b c: ")
     (input a b c)
     (discrim := (- (^ b 2) (* (* 4 a) c)))
     ( if (>= discrim 0) (
	  (discroot := (^ discrim 0.5))
          (display "root1 is " (/ (+ (- b) discroot) (* 2 a)) nl)
          (display "root2 is " (/ (- (- b) discroot) (* 2 a)) nl)
	  )
	  (display "Sorry!" nl)
	  (display "This equation has no real roots!" nl)
	  )
     )
   )

(define quad4
  '(
     (display "Enter the values of  a b c: ")
     (input a b c)
     (discrim := (- (^ b 2) (* (* 4 a) c)))
     (if (> discrim 0) (
	 (discroot := (^ discrim 0.5))
         (display "root1 is " (/ (+ (- b) discroot) (* 2 a)) nl)
         (display "root2 is " (/ (- (- b) discroot) (* 2 a)) nl)
	 )
     (if (= discrim 0)(
	 (root := (/ (- b) (* 2 a)))
	 (display "Double root at " root nl)
	 )
         (display "No real roots!" nl)
     ))
   )
 )


(define quad5
  '(
     (continue := 1)
     (while (= continue 1)
         (display "Enter the values of  a b c: ")
         (input a b c)
	 (discrim := (- (^ b 2) (* (* 4 a) c)))
         (if (> discrim 0) (
	     (discroot := (^ discrim 0.5))
             (display "root1 is " (/ (+ (- b) discroot) (* 2 a)) nl)
             (display "root2 is " (/ (- (- b) discroot) (* 2 a)) nl)
	     )
         (if (= discrim 0)(
	     (root := (/ (- b) (* 2 a)))
	     (display "Double root at " root nl)
	     )
             (display "No real roots! " nl)
         ))
	 (display "Solve another? (1 = yes, 0 = no)" nl)
         (input continue)
	 )
      (display "Thanks for using the qaudratic solver!" nl)
      (display "Please consider supporting the dedicated" nl)
      (display "programmers who created this app!" nl)
   )
 )


