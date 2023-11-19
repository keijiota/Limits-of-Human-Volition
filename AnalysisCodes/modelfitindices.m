% Copyright (C) Keiji Ota 2023
% Email: k.ota@ucl.ac.uk or k.ota@qmul.ac.uk
% Edited: 2023-11-18 

function [fitindx] = modelfitindices(maxLL,n,k)

fitindx.aic  = -2*maxLL + 2*k;
fitindx.aicc = -2*maxLL + 2*k + 2*(k.*(k+1))./(n-k-1) ;

% evidenceratio =  exp((delta_AICc)/2) ; 

end