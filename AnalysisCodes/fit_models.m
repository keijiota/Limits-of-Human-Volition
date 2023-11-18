clear; close all;
% Credit: Keiji Ota (email: k.ota@ucl.ac.uk or k.ota@qmul.ac.uk)
% Date: 2023-11-18 (version 1)
% this code requires to install BADS package on your machine. 
% Bayesian adaptive direct search (BADS): https://github.com/acerbilab/bads

%% loading data

load('data_structure');
subN = size(dat.wt,1); c = 1:3; C = 3;

% this is the code for fitting models to the participants' choice data 
% try with a few numbers of "nrep" and a few numbers of "subN"
% otherwise it will take very long time. 

%% model fitting
LB  = [0 0 0 0 0];  UB = [1 20 0.2 1 1];
PLB = [.01 .01 .001 .01 .01]; PUB = [0.95 20 0.1 .99 .99];

ison = 1; nrep = 20;
if ison == 1
    for subi = 1:subN
        for ib = 1:2
            str = dat.nTr(ib,subi)+1; etr = dat.nTr(ib+1,subi);
            data = [dat.wtbin{subi}(str:etr), dat.bet{subi}(str:etr), dat.point2{subi}(str:etr)];
            data(:,3) = data(:,3)+1; len = length(data);
           
            Q_RL = [.5 .5 .5]; Q_1BL = -[.5 .5 .5]; Q_2BL = -[.5 .5 .5];  Qinit = [Q_RL; Q_1BL; Q_2BL];
            
            %-----inference-----
%             x = [0 0 0 0]; model = 1; k = 0; % Null model
%             logLikeEach = recover_models(data,x,model,Qinit);
%             maxLL = sum(logLikeEach); fitindx = modelfitindices(maxLL,len,k);
%             prm_null{ib}(subi,:) = [x maxLL fitindx.aicc len];

            model = 1; k = 2; Nll = []; xx = []; % bias only          
            for rep = 1:nrep
               [x,nll] = MLE_models(data,model,Qinit,LB,[0 UB(2:3) 0 0],[0 0 0 0 0],[0 PUB(2:3) 0 0],[]);                            
               Nll(rep,1) = nll; xx(rep,:) = x;
            end
            [~,mtmp] = min(Nll); nll = Nll(mtmp); x = xx(mtmp,:);
            maxLL = -nll; fitindx = modelfitindices(maxLL,len,k);
            prm_bias{ib}(subi,:) = [x maxLL fitindx.aicc len];

            model = 1; k = 3; Nll = []; xx = []; % RL        
            for rep = 1:nrep
               [x,nll] = MLE_models(data,model,Qinit,LB,[UB(1:3) 0 0],[PLB(1:3) 0 0],[PUB(1:3) 0 0],[]);                            
               Nll(rep,1) = nll; xx(rep,:) = x;
            end
            [~,mtmp] = min(Nll); nll = Nll(mtmp); x = xx(mtmp,:);
            maxLL = -nll; fitindx = modelfitindices(maxLL,len,k);
            prm_rl{ib}(subi,:) = [x maxLL fitindx.aicc len];

            model = 2; k = 3; Nll = []; xx = []; % 1st BL
            for rep = 1:nrep
               [x,nll] = MLE_models(data,model,Qinit,[LB(1:3) 0 0],[UB(1:3) 0 0],[PLB(1:3) 0 0],[PUB(1:3) 0 0],[]);                            
               Nll(rep,1) = nll; xx(rep,:) = x;
            end
            [~,mtmp] = min(Nll); nll = Nll(mtmp); x = xx(mtmp,:);
            maxLL = -nll; fitindx = modelfitindices(maxLL,len,k);
            prm_1bl{ib}(subi,:) = [x maxLL fitindx.aicc len];

            model = 3; k = 3; Nll = []; xx = []; % 2nd BL
            for rep = 1:nrep
               [x,nll] = MLE_models(data,model,Qinit,[LB(1:3) 0 0],[UB(1:3) 0 0],[PLB(1:3) 0 0],[PUB(1:3) 0 0],[]);                 
               Nll(rep,1) = nll; xx(rep,:) = x;
            end
            [~,mtmp] = min(Nll); nll = Nll(mtmp); x = xx(mtmp,:);
            maxLL = -nll; fitindx = modelfitindices(maxLL,len,k);
            prm_2bl{ib}(subi,:) = [x maxLL fitindx.aicc len];

            model = 4; k = 4; Nll = []; xx = []; % RL + 1st BL
            for rep = 1:nrep
               [x,nll] = MLE_models(data,model,Qinit,[LB(1:4) 0],[UB(1:4) 0],[PLB(1:4) 0],[PUB(1:4) 0],[]);                            
               Nll(rep,1) = nll; xx(rep,:) = x;
            end
            [~,mtmp] = min(Nll); nll = Nll(mtmp); x = xx(mtmp,:);
            maxLL = -nll; fitindx = modelfitindices(maxLL,len,k);
            prm_rl_1bl{ib}(subi,:) = [x maxLL fitindx.aicc len];

            model = 5; k = 4; Nll = []; xx = []; % 1st BL + 2nd BL
            for rep = 1:nrep
               [x,nll] = MLE_models(data,model,Qinit,[LB(1:4) 0],[UB(1:4) 0],[PLB(1:4) 0],[PUB(1:4) 0],[]);                            
               Nll(rep,1) = nll; xx(rep,:) = x;
            end
            [~,mtmp] = min(Nll); nll = Nll(mtmp); x = xx(mtmp,:);
            maxLL = -nll; fitindx = modelfitindices(maxLL,len,k);
            prm_1bl_2bl{ib}(subi,:) = [x maxLL fitindx.aicc len];            
        end
    end
end
% save data data_fit_models


