# GBD+MUnCH

Copyright (c) 2023 Andrés Córdoba

email: andcorduri@gmail.com

## Papers with detailed explanations of the procedures used in this code

1. A. Córdoba and J. D. Schieber, “MUnCH: a calculator for propagating statistical and other sources of error in passive microrheology,” Rheologica Acta, vol. 61, pp. 49–57, 2022. https://rdcu.be/cBqmk

2. A. Córdoba, T. Indei, and J. D. Schieber, “Elimination of inertia from a generalized Langevin equation: Applications to microbead rheology modeling and data analysis,” Journal of Rheology, vol. 56, no. 1, pp. 185–212, 2012. https://doi.org/10.1122/1.3675625

## Instructions

This code performs generalized Brownian dynamics (GBD) simulations of a microparticle embedded in a viscoelastic fluid. It takes as input the dynamic modulus of the fluid represented with a multi-mode Maxwell model. The code then analyzes the resulting mean-squared displacement (MSD) of the particle and using the generalized Stokes-Einstein relation calculates an output modulus. The input and output modulus are compared to evaluate the data analysis procedure and the effect of the statistical error in passive microrheology. The input dynamic modulus of the fluid should be set in the file input.csv (see description there for details).

The code requires the following (open source compilers and/or interpreters) to be installed:

Racket: https://racket-lang.org/

Maxima: https://wxmaxima-developers.github.io/wxmaxima/

Python: https://www.python.org/

The script run.sh can be used to run a whole simulation, in which first a memory kernel is calculated using the Maxima mkernel.wxm. Using this memory kernel, the GBD is run using run_gbd.rkt, producing a trajectory file (in units of mV). The MSD and its uncertainty are then calculated in Python using blocking transformations (MUnCH_v1.py).The first column in the MSD file is the time, the second column the MSD and the third column the MSD uncertainty. The script msd.wxm generates an initial guess for fitting the MSD with an analytic function. This is used in MUnCH.py when performing the data analysis.

*A Mathematica Notebook version of the MUnCH script can also be found at:* https://notebookarchive.org/2022-02-47qzo2x

## Updates

1. October 14 2022: A new version of the MUnCH python code (MUnCH_numba.py) has been added that uses the Numba JIT compiler. This version is much faster than the uncompiled version.

2. January 29 2023: A new version of the MUnCH python code (MUnCH_LF.py) has been added that works well with very large data files that can not be loaded all at once. It also uses the Numba JIT compiler.

3. February 16 2023: A new version of the MUnCH python code (MUnCH_on-the-fly.py) has been added that generates the bead trajectory in the same python script and calculates the MSD and its uncertainty on-the-fly without storing the raw trajectory data this version also uses the CPU Numba jit compiler.

4. February 27 2024: Bash scripts (run_ensemble.sh and run_enspara.sh) were added. These files run a workflow that generates an ensemble of trajectories then calculates the MSD and its uncertainty for each trajectory using MUnCH_numba.py. Then using ensemble_av.py the script calculates the ensemble average of the MSD and analyzes this average. The script run_enspara.sh uses GNU parallel while the script run_ensemble.sh does everything sequentially.


