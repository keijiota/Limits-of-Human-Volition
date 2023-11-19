# Limits-of-Human-Volition
This GitHub repository shares the analyses codes which generated the figures in the following article
- Ota, K., Charles, L., & Haggard, P. (2023). Autonomous behaviour and the limits of human volition. Cognition.
  
### analysis codes
I assume that the programming codes will be run in the following order. 
  1. Figure2CD.m
  2. Figure3DEF_SupplFig1.m
  3. autoregression_model.m
  4. autoregression_data.m
  5. LaggedRegression.R
  6. Figure5ABC.m
  7. fit_models.m
  8. Figure5D_SupplFig2.m

### data frame
A Matlab file 'data_structure.mat' is the data frame for participants' responses (N=152). 
Some important variables are 
  dat.nTr (5*152): the 1st row is always zero
                   the 2nd row is the trial number for the end of the baseline block
                   the 3rd row is the trial number for the end of block 1 (the punishment of choice bias)
                   the 4th row is the trial number for the end of block 2 (the punishment of transition bias)
                   the 5th row is the trial number for the end of block 3 (the punishment of reinforcement bias)       
  dat.wt: participant's wait time (seconds)
  dat.wtbin:  a wait time interval chosen by each participant (1: early [0-1.5 s], 2: middle [1.5-3.0 s], 3: late [3.0-4.5 s])
  dat.bet:  a wait time interval chosen/blocked by a virtual competitor 
  dat.point2: 0 is success, -1 is failure (this includes a timeout trial)
  
If you have any questions or find a bug, please contact me at k.ota@ucl.ac.uk or k.ota@qmul.ac.uk 
