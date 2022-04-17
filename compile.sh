#!/bin/bash

raco exe run_gbd.rkt

raco distribute ./compiled run_gbd
wait
rm run_gbd
