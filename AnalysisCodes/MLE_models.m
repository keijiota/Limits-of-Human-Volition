% Copyright (C) Keiji Ota 2023
% Email: k.ota@ucl.ac.uk or k.ota@qmul.ac.uk
% Edited: 2023-11-18 

% this is the code for maxmising the log-likelihood of the data given model parameters 
% this code requires to install BADS package on your machine. 
% Bayesian adaptive direct search (BADS): https://github.com/acerbilab/bads

function [x,nll,f,o] = MLE_models(data,model,Qinit,LB,UB,PLB,PUB,nonbcon)
nAll = size(data,1); 
x0 = LB + rand(1,numel(LB)) .* (UB-LB); 
t = [0 1.5 3]; 
options.UncertaintyHandling = 0;
options.Display = 'final';  % 'notify', 'final', 'iter'
[x,nll,f,o] = bads(@NegLogLike,x0,LB,UB,PLB,PUB,nonbcon,options);

    function [nll] = NegLogLike(prm)
        Q_hat = nan(nAll,3); logLikeEach = nan(nAll,1);       
        Q_RL = Qinit(1,:); Q_1BL = Qinit(2,:); Q_2BL = Qinit(3,:);

        beta = prm(2); gamma = prm(3); disc = exp(-gamma.*t);
        alpha = prm(1); lambda = prm(4);

        if model == 1
            Q = Q_RL;
        elseif model == 2
            Q = Q_1BL;
        elseif model == 3
            Q = Q_2BL;
        elseif model == 4
            Q = (1-lambda)*Q_RL + lambda*Q_1BL;
        elseif model == 5
            Q = (1-lambda)*Q_1BL + lambda*Q_2BL;
        end

        for itr = 1:nAll
            Q_hat(itr,1:3) = Q; % Q values 
            p = exp(beta*(Q+disc)) / sum(exp(beta*(Q+disc))); % choice probabilities based on a soft max function
            a = data(itr,1); bet = data(itr,2); r = data(itr,3); % a: participant's action, bet: opponent's action, r: reward obtained

            % updates qvals
            oppact = [0 0 0]; oppact(bet) = -1; % [Eerly, Middle, Late] put a negative reward for an action interval the opponent selected
            ownact = [0 0 0]; ownact(a) = -1; % [E,M,L] put a negative reward for an action interval the participant selected
            if model == 1
                Q_RL(a) = Q_RL(a) + alpha * (r - Q_RL(a));
                Q = Q_RL;
            elseif model == 2
                Q_1BL = Q_1BL + alpha * (oppact - Q_1BL);
                Q = Q_1BL;

            elseif model == 3
                Q_2BL = Q_2BL + alpha * (ownact - Q_2BL);
                Q = Q_2BL;

            elseif model == 4
                Q_RL(a) = Q_RL(a) + alpha * (r - Q_RL(a));
                Q_1BL = Q_1BL + alpha * (oppact - Q_1BL);
                Q = (1-lambda) * Q_RL + lambda * Q_1BL;

            elseif model == 5
                Q_1BL = Q_1BL + alpha * (oppact - Q_1BL);
                Q_2BL = Q_2BL + alpha * (ownact - Q_2BL);
                Q = (1-lambda) * Q_1BL + lambda * Q_2BL;
            end
            %                 [a bet r; Q_BL; Q_Opt; Q]
            logLikeEach(itr,1) = log(p(a));
        end
        nll = - sum(logLikeEach); % negative log likelihood

    end
end

