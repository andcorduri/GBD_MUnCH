#lang racket

;Author: Andres Cordoba
;Copyright (2022) Andres Cordoba
;This script is distributed under the MIT License.
;email: andcorduri@gmail.com

(require (planet dherman/csv-write:1:2/csv-write))
(require (planet williams/science:4:7/science))

;; position in a 2D matrix
(define (2dmp matrix p1 p2)
  (list-ref (list-ref matrix p1) p2))

;; dot product between matrix and vector
(define (dot mat vect)
  (for/list ([i (in-range (length mat))])
    (foldl + 0 (for/list ([j (in-range (length vect))])
                 (* (2dmp mat i j)(list-ref vect j))))))

;; matrix A in Ornstein-Ulembech process
(define (a c l u) 
  (append
   (for/list ([i (in-range (length c))])
     (append
      (for/list ([j (in-range (length c))])
        (if (equal? i j) (/ 1 (list-ref l i)) 0))
      (list u)))
   (list
    (append
     (for/list ([i (in-range (length c))])
       (/ (list-ref c i) u))
     (list u)))))

;; matrix B in Ornstein–Uhlenbeck process
(define (b c l u) 
  (append
   (for/list ([i (in-range (length c))])
     (append
      (for/list ([j (in-range (length c))])
        (if (equal? i j) (sqrt(* 2 (/ (expt u 2) (*(list-ref c i)(list-ref l i))))) 0))
      (list 0)))
   (list
    (append
     (for/list ([i (in-range (length c))])
       (sqrt (* 2 (list-ref c i) (list-ref l i))))
     (list (sqrt (* 2(- u (foldl + 0 (map * c l))))))))))

;; Equilibrium initial condition
(define (initcond c l u randsr randsq)
  (append
   (for/list ([i (in-range (length c))])
     (random-gaussian (vector-ref randsq i) 0 (sqrt (/ (expt u 2) (list-ref c i)))))
   (list (random-gaussian (vector-ref randsr 0) 0 1.0))))

;; time step function for the Ornstein–Uhlenbeck process with euler algorithm
(define (step rands mata matb vect deltat)
  (map +
       (map - vect (dot mata (map (lambda (x) (* x deltat)) vect)))
       (dot matb
            (for/list ([i (in-range (length (list-ref matb 0)))])
              (random-gaussian (vector-ref rands (+ i 1)) 0 (sqrt deltat))))))

;; recursive function for the time evolution of the Ornstein–Uhlenbeck process
(define (evolution rands1 vect01 c l u lens sens mata matb
                   deltat tt n conts samp vectores1)
  (cond
    [(equal? n tt)]
    [else 
     (cond 
       [(equal? n (* conts samp))
        (vector-set! vectores1 conts (/(*(list-ref vect01 (-(length vect01)1))lens)sens))
        (set! conts (+ conts 1))])
     (set! mata (a c l u))
     (set! vect01 (step rands1 mata matb vect01 deltat))
     (evolution rands1 vect01 c l u lens sens mata matb
                deltat tt (+ n 1) conts samp vectores1)]))


;; simulate trajectory
(define (runsimu c l u lens sens dsens deltat tst inp it nod)
  
  (define randsr1 (make-random-source-vector 3 (+(*(string->number inp)nod)it)))
  (define randsq1 (make-random-source-vector (* 3 (length c)) (+(*(+ (string->number inp) 3)nod)it)))
  (define rands1 (vector-append randsq1 randsr1))
  
  (define nit2 (inexact->exact(round (/ tst deltat))))
  
  (define vectr1 (initcond c l u randsr1 randsq1))

  (define res4 (make-vector nit2))
  (define matb (b c l u))
  (define mata (a c l u))
  
  (evolution rands1 vectr1 c l u lens sens mata matb deltat nit2 0 0 1 res4)
 
  
  (list (for/list ([i (in-range nit2)]) (list (* i deltat)(vector-ref res4 i)))))


;; Save trajectory
(define (savesimu c l u lens sens dsens deltat tst inp)
  
  (define out1 (open-output-file (string-append "Vdata_"  "traj_" (number->string(*(string->number inp))) ".csv") #:exists 'replace))
  
  (define rest1 (runsimu c l u lens sens dsens deltat tst inp 0 0))
  (define calmsd (list-ref rest1 0))

  (write-table calmsd out1)
  
  (close-output-port out1))

(provide
 (rename-out (evolution ev_gbd_data)
             (runsimu runsimu_gbd_data)
             (savesimu savesimu_gbd_data)))