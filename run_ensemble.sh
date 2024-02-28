#!/bin/bash

#number of beads
NN=4

mkdir outputs

cd ./outputs

cp ../input.csv .

wait

maxima < ../mkernel.wxm --very-quiet

#Run the GBD sequentially for NN number of beads
i=1
while [ $i -le ${NN} ]
do
  RUN=$i
  sed -i "s/<RUN>/$RUN/" input.csv
  racket ../run_gbd.rkt ${RUN}
  ((i=i+1))
done


wait 

maxima < ../msd.wxm --very-quiet

wait

#Run the MUnCH sequentially for the NN trajectories
i=1
while [ $i -le ${NN} ]
do
  RUN=$i
  python3 ../MUnCH_numba.py ${RUN}
  ((i=i+1))
done

wait

#Calculate the ensemble average
python3 ../ensemble_av.py ${NN}

