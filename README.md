MAGORINO: Magnitude-only fat fraction and R2* estimation with Rician noise modelling.

The code in this repository enables implementation of the method and experiments described in: 
Bray TJP, Bainbridge A, Lim EA, Hall-Craggs MA, Zhang H. MAGORINO: Magnitude-only fat fraction and R2* estimation with Rician noise modelling. Magn Reson Med 2023. doi: 10.1002/mrm.29493

Briefly, MAGORINO is a method for proton density fat fraction (PDFF) and R2* estimation, which incorporates (i) Rician noise–based likelihood optimization based on the signal magnitude and (ii) two-point search of the likelihood function to ensure that both global and local optima are explored.

To use the method or to try any of the experiments in the paper, start by creating an imDataParams structure with the following fields:

- imDataParams.images is an nX by nY by nZ by 1 by nTE complex-valued array, where nX is the number of pixels in each slice in the x dimension, nY is the number of pixels in the y dimension, nZ is the number of slices, and nTE is the number of echo times. Each element in imDataParams.images gives the complex signal in a particular voxel, at a particular echo time. 
- imDataParams.TE is a 1 x nTE row vector containing the echo times in seconds, e.g. [0.0012 0.0028 0.0044 0.0060 0.0076 0.0092]
- imData.FieldStrengh is a scalar value giving the field strength in Tesla, e.g. 3

Then run

maps = MultistepFitImage(imDataParams,roi)

Alternatively, to run simulation experiments and other things, try taking a look at the master script master.m in the 'Experiments' folder. 

For more information, feel free to contact me at 
t.bray@ucl.ac.uk

