#!/bin/bash

RUN=1

mkdir outputs

cd ./outputs

cp ../input.csv .

wait

maxima < ../mkernel.wxm --very-quiet


sed -i "s/<RUN>/$RUN/" input.csv
racket ../run_gbd.rkt

wait 

maxima < ../msd.wxm --very-quiet

wait

python3 ../MUnCH_numba.py
