clear; close all;

% Credit: Keiji Ota (email: k.ota@ucl.ac.uk or k.ota@qmul.ac.uk)
% Date: 2023-11-18 (version 1)

%%
nSeq = 10; nPast = 60;
c = 3; t = [0 1.5 3];

prm = [0.3 10 0.2 0.5];
nTr = 60;
nboot = 10000; % try with just 100 repetition

for algo = 4
    for model = 1:3
        mtx = [];
        for iboot = 1:nboot
            data = []; Q_hat = nan(nTr,3);
            Q_RL = [.5 .5 .5]; Q_1BL = -[.5 .5 .5]; Q_2BL = -[.5 .5 .5];  Qinit = [Q_RL; Q_1BL; Q_2BL];

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
            elseif model == 6
                Q = [0 0 0];
            end

            for itr = 1:nTr
                Q_hat(itr,1:3) = Q;
                chprob = exp(beta*(Q+disc)) / sum(exp(beta*(Q+disc)));
                a = randsample(c,1,true,chprob);

                if algo == 1
                    cond_wt = [ones(1,98) ones(1,1)*2 ones(1,1)*3];
                elseif algo == 2 % punishment of choice bias
                    cond_wt = Algo1(data,nSeq);
                elseif algo == 3 % punishment of transition bias
                    cond_wt = Algo2(itr, nSeq, nPast, data);
                elseif algo == 4 % punishment of reinforcement bias
                    cond_wt = Algo3(itr, nSeq, nPast, data);
                elseif algo == 5
                    cond_wt = [1 1 1 2 2 2 3 3 3]';
                end
                cond_wt1 = Algo1(data,nSeq);
                cond_wt2 = Algo2(itr, nSeq, nPast, data);
                cond_wt3 = Algo3(itr, nSeq, nPast, data);

                freq = [sum(cond_wt == 1),sum(cond_wt == 2),sum(cond_wt == 3)];
                freq = freq / sum(freq); if isnan(freq) freq = [1/3 1/3 1/3]; end
                bet = randsample(c,1,true,freq); r = 1 - (a == bet);
                data(itr,:) = [a, bet, r];

                % updates qvals
                oppact = [0 0 0]; oppact(bet) = -1;
                ownact = [0 0 0]; ownact(a) = -1;
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

                elseif model == 6
                    Q = Q;
                end
                %      [a bet r; Q_RL; Q_1BL; Q_2BL; Q]
                %      [(1-lambda) * Q_BL; lambda * Q_Opt; Q]
            end

            y = data(6:end,1); % next choice
            own1 = data(5:end-1,1); opt1 = data(5:end-1,2);
            own2 = data(4:end-2,1); opt2 = data(4:end-2,2);
            own3 = data(3:end-3,1); opt3 = data(3:end-3,2);
            own4 = data(2:end-4,1); opt4 = data(2:end-4,2);
            own5 = data(1:end-5,1); opt5 = data(1:end-5,2);

            X = [own1 opt1 own2 opt2 own3 opt3 own4 opt4 own5 opt5];

            %----
            n = size(X,1);
            mtx = [mtx; ones(n,1)*iboot, y, X] ;
        end

        X = mtx(:,3:end); y = mtx(:,2);
        [B,dev,stats] = mnrfit(X,y,'model','ordinal');
        Beta{model,algo} = B(3:end); Stats{model,algo} = stats.p(3:end); SE{model,algo} = stats.se(3:end);

        % BETA{model,algo} = Beta; Condprob_own{model,algo} = condprob_own; Condprob_opt{model,algo} = condprob_opt;
    end
end

Beta_mdl = Beta;
Stats_mdl = Stats;
SE_mdl = SE;
% save autoreg_model_prm Beta_mdl Stats_mdl SE_mdl prm


%%
function [cond_wt] = Algo1(wt,nSeq)
cond_wt = [];
len = size(wt,1); if len-nSeq < 0  tmp = 1; else tmp = len-nSeq+1; end
cond_wt  = wt(tmp:len);
end

function [cond_wt] = Algo2(itr, nSeq, nPast, data)
cond_wt = [];

if isempty(data) ~= 1
    wt = data(:,1); wt_n1 = data(end,1);
    for ii = itr-2:-1:itr-nPast-1
        if ii <= 0 break; end
        if wt(ii) == wt_n1
            cond_wt = [cond_wt; wt(ii+1)]; %wt(ii)
        end
        if length(cond_wt) == nSeq break; end
    end
end
end

function [cond_wt] = Algo3(itr, nSeq, nPast, data)
cond_wt = [];
if isempty(data) ~= 1
    wt = data(:,1); wt_n1 = data(end,1);
    pt = data(:,3); pt_n1 = data(end,3);
    for ii = itr-2:-1:itr-nPast-1
        if ii <= 0 break; end
        if pt(ii) == 0 && pt_n1 == 0
            if wt(ii) == wt_n1
                cond_wt = [cond_wt; wt(ii+1)];
            end
        elseif pt(ii) == 1 && pt_n1 == 1
            if wt(ii) == wt_n1
                cond_wt = [cond_wt; wt(ii+1)];
            end
        end
        if length(cond_wt) == nSeq break; end

    end
end
end
