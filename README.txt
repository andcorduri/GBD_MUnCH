
########################### GBD+MUnCH ##################################
################Copyright (c) 2022 Andres Cordoba#######################
################email: andcorduri@gmail.com#############################

This code performs generalized Brownian dynamics (GBD) simulations of 
a micro particle embedded in a viscoelastic fluid. It takes
as input the dynamic modulus of the fluid represented with 
a multi-mode Maxwell model. The code then analyzes the resulting 
mean-squared displacement (MSD) of the particle and using the 
generalized Stokes-Einstein relation calculates an output 
modulus. The input and output modulus are compared to evaluate 
the data analysis procedure and the effect of the statistical error 
in passive microrheology. The input dynamic modulus of the fluid 
should be set in the file input.csv (see description there for details).

The code requires the following (open source compilers and/or interpreters)
to be installed:

Racket: https://racket-lang.org/
Maxima: https://maxima.sourceforge.io/
Python: https://www.python.org/

The script run.sh can be used to run a whole simulation, in 
which first a memory kernel is calculated using 
the Maxima mkernel.wxm.
Using this memory kernel, the GBD is run using run_gbd.rkt, 
producing a trajectory file (in units of mV). The 
MSD and its uncertainty are then
calculated in Python using blocking transformations (MUnCH_v1.py).
The first column in the MSD file is the time, the second column the MSD
and the third column the MSD uncertainty.


Papers where you can find the detailed explanations of the 
procedures used in this code: 

A. Córdoba, T. Indei, and J. D. Schieber, 
“Elimination of inertia from a generalized Langevin equation: 
Applications to microbead rheology modeling and data analysis,” 
Journal of Rheology, vol. 56, no. 1, pp. 185–212, 2012.

A. Córdoba and J. D. Schieber, “MUnCH: a calculator for 
propagating statistical and other sources of error in 
passive microrheology,” Rheologica Acta, vol. 61, pp. 49–57, 2022.

