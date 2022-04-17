#!/bin/bash

RUN=1

mkdir outputs

cd ./outputs

cp ../input.csv .

wait

maxima < ../mkernel.wxm --very-quiet


sed -i "s/<RUN>/$RUN/" input.csv
../compiled/bin/run_gbd

wait 

python2.7 ../MUnCH_v1.py
