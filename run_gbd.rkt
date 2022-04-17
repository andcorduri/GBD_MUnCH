#lang racket

;Author: Andres Cordoba
;Copyright (2022) Andres Cordoba
;This script is distributed under the MIT License.
;email: andcorduri@gmail.com

(require "main_gbd.rkt")
(require (planet neil/csv:1:6))

(define inpar (csv->list (open-input-file "input.csv")))
(define inpar2 (csv->list (open-input-file "cs.csv")))
(define inpar3 (csv->list (open-input-file "Ls.csv")))

(define type (list-ref(list-ref inpar 0)1))

(define kB (* 1.38 (expt 10 -23)))
(define T (+ 20 273.15))


(cond
  [(equal? type "run_gbd")
   (define cim0 (if (>(length inpar2)0) (list-ref inpar2 0) inpar2))
   (define cim (for/list ([j (in-range 0 (length cim0))])
                 (string->number (list-ref cim0 j))))
   (define lim0 (if (>(length inpar3)0) (list-ref inpar3 0) inpar3))
   (define lim (for/list ([j (in-range 0 (length lim0))])
                 (string->number (list-ref lim0 j))))
   (define uim (/ 1.0 (string->number (list-ref(list-ref inpar 4)1))))
   (define stiffin (string->number (list-ref(list-ref inpar 5)1)))
   (define lensin (*(sqrt (/ (* kB T) (* stiffin (/(expt 10 -12)(expt 10 -9)))))(expt 10 9)))
   (define sensin (string->number (list-ref(list-ref inpar 6)1)))
   (define dsensin (string->number (list-ref(list-ref inpar 7)1)))
   (define dvin (string->number (list-ref(list-ref inpar 8)1)))
   (define lenin2 (inexact->exact(string->number (list-ref(list-ref inpar 9)1))))
   (define dtin (string->number (list-ref(list-ref inpar 10)1)))
   (define inp (list-ref(list-ref inpar 11)1))
   (savesimu_gbd_data cim lim uim lensin sensin dsensin dvin dtin lenin2 inp)]
  [else (error "Simulation type not implemented")]
  )
