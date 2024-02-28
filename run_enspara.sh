#!/bin/bash

mkdir outputs

cd ./outputs

cp ../input.csv .

wait

maxima < ../mkernel.wxm --very-quiet


#Run the GBD in parallel for 4 number of beads
parallel racket ../run_gbd.rkt ::: {1..4}

wait 

maxima < ../msd.wxm --very-quiet

wait

#Run the MUnCH in parallel for the 4 trajectories
parallel python3 ../MUnCH_numba.py ::: {1..4}

wait

#Calculate the ensemble average
python3 ../ensemble_av.py 4
