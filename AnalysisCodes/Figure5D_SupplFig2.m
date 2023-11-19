clear; close all;

% Copyright (C) Keiji Ota 2023
% Email: k.ota@ucl.ac.uk or k.ota@qmul.ac.uk
% Edited: 2023-11-18 
% this code requires you to install SPM12: https://www.fil.ion.ucl.ac.uk/spm/software/spm12/

%%
load data_fit_models;

clearvars -except prm_bias prm_rl prm_1bl prm_2bl prm_1bl_2bl prm_rl_1bl dklov dklpwl dklpw dklpl subN score


%% sanity check plotting AICc values and the negative log likelihood

lw = 0.75; wd = 0.8;
x = [1 2 3 4 5.3 6.3;
    9 10 11 12 13.3 14.3;
    16 17 18 19 20.3 21.3;
    23 24 25 26 27.3 28.3];

c1 = [.75 .75 .75]; c2 = [1 0.85 0]; c3 = [1 0.2 0]; c4 = [0.65 0 0];
xl = {'Stochastic', 'RL','1BL','2BL','RL+1BL','1BL+2BL'};

for j = 1:2
    if j == 1
        idx_biasrand = [prm_bias{1}(:,7) prm_bias{2}(:,7) prm_bias{3}(:,7) prm_bias{4}(:,7)];
        idx_rl = [prm_rl{1}(:,7) prm_rl{2}(:,7) prm_rl{3}(:,7) prm_rl{4}(:,7)];
        idx_1bl = [prm_1bl{1}(:,7) prm_1bl{2}(:,7) prm_1bl{3}(:,7) prm_1bl{4}(:,7)];
        idx_2bl = [prm_2bl{1}(:,7) prm_2bl{2}(:,7) prm_2bl{3}(:,7) prm_2bl{4}(:,7)];

        idx_rl_1bl = [prm_rl_1bl{1}(:,7) prm_rl_1bl{2}(:,7) prm_rl_1bl{3}(:,7) prm_rl_1bl{4}(:,7)];
        idx_1bl_2bl = [prm_1bl_2bl{1}(:,7) prm_1bl_2bl{2}(:,7) prm_1bl_2bl{3}(:,7) prm_1bl_2bl{4}(:,7)];

    else
        idx_biasrand = [prm_bias{1}(:,6) prm_bias{2}(:,6) prm_bias{3}(:,6) prm_bias{4}(:,6)];
        idx_rl = [prm_rl{1}(:,6) prm_rl{2}(:,6) prm_rl{3}(:,6) prm_rl{4}(:,6)];
        idx_1bl = [prm_1bl{1}(:,6) prm_1bl{2}(:,6) prm_1bl{3}(:,6) prm_1bl{4}(:,6)];
        idx_2bl = [prm_2bl{1}(:,6) prm_2bl{2}(:,6) prm_2bl{3}(:,6) prm_2bl{4}(:,6)];

        idx_rl_1bl = [prm_rl_1bl{1}(:,6) prm_rl_1bl{2}(:,6) prm_rl_1bl{3}(:,6) prm_rl_1bl{4}(:,6)];
        idx_1bl_2bl = [prm_1bl_2bl{1}(:,6) prm_1bl_2bl{2}(:,6) prm_1bl_2bl{3}(:,6) prm_1bl_2bl{4}(:,6)];
    end


    figure; hold on
    bar(x(1,1), sum(idx_biasrand(:,1)), wd, 'FaceColor',c1, 'linewidth',lw);
    bar(x(1,2), sum(idx_rl(:,1)), wd,'FaceColor',c1, 'linewidth',lw);
    bar(x(1,3), sum(idx_1bl(:,1)), wd,'FaceColor',c1, 'linewidth',lw);
    bar(x(1,4), sum(idx_2bl(:,1)), wd, 'FaceColor',c1, 'linewidth',lw);
    bar(x(1,5), sum(idx_rl_1bl(:,1)), wd, 'FaceColor',c1, 'linewidth',lw);
    bar(x(1,6), sum(idx_1bl_2bl(:,1)), wd, 'FaceColor',c1, 'linewidth',lw);

    xlim([0 7]); xticks([x(1,1:6)]); xticklabels(xl);
    if j == 1
        ylim([0 12500]); yticks(0:2500:20000); ylabel('Summed AICc');
    else
        ylabel('NegMaxLogLike');
    end
    myfigAI(280,270,10.5);

    figure; hold on
    bar(x(2,1), sum(idx_biasrand(:,2)), wd, 'FaceColor',c2, 'linewidth',lw);
    bar(x(2,2), sum(idx_rl(:,2)), wd,'FaceColor',c2, 'linewidth',lw);
    bar(x(2,3), sum(idx_1bl(:,2)), wd,'FaceColor',c2, 'linewidth',lw);
    bar(x(2,4), sum(idx_2bl(:,2)), wd, 'FaceColor',c2, 'linewidth',lw);
    bar(x(2,5), sum(idx_rl_1bl(:,2)), wd, 'FaceColor',c2, 'linewidth',lw);
    bar(x(2,6), sum(idx_1bl_2bl(:,2)), wd, 'FaceColor',c2, 'linewidth',lw);

    bar(x(3,1), sum(idx_biasrand(:,3)), wd, 'FaceColor',c3, 'linewidth',lw);
    bar(x(3,2), sum(idx_rl(:,3)), wd,'FaceColor',c3, 'linewidth',lw);
    bar(x(3,3), sum(idx_1bl(:,3)), wd,'FaceColor',c3, 'linewidth',lw);
    bar(x(3,4), sum(idx_2bl(:,3)), wd, 'FaceColor',c3, 'linewidth',lw);
    bar(x(3,5), sum(idx_rl_1bl(:,3)), wd, 'FaceColor',c3, 'linewidth',lw);
    bar(x(3,6), sum(idx_1bl_2bl(:,3)), wd, 'FaceColor',c3, 'linewidth',lw);

    bar(x(4,1), sum(idx_biasrand(:,4)), wd, 'FaceColor',c4, 'linewidth',lw);
    bar(x(4,2), sum(idx_rl(:,4)), wd,'FaceColor',c4, 'linewidth',lw);
    bar(x(4,3), sum(idx_1bl(:,4)), wd,'FaceColor',c4, 'linewidth',lw);
    bar(x(4,4), sum(idx_2bl(:,4)), wd, 'FaceColor',c4, 'linewidth',lw);
    bar(x(4,5), sum(idx_rl_1bl(:,4)), wd, 'FaceColor',c4, 'linewidth',lw);
    bar(x(4,6), sum(idx_1bl_2bl(:,4)), wd, 'FaceColor',c4, 'linewidth',lw);

    xlim([7 30]); xticks([x(2,1:6), x(3,1:6),x(4,1:6)]); xticklabels([xl xl xl]);
    if j == 1
        ylim([17000 20000]); yticks(0:1000:20000); ylabel('Summed AICc');
    else
        % ylim([17000 20000]); yticks(0:1000:20000);
        ylabel('NegMaxLogLike');
    end
    myfigAI(580,275,10.5);
end

%% Figure 5D
aicc_biasrand = [prm_bias{1}(:,7) prm_bias{2}(:,7) prm_bias{3}(:,7) prm_bias{4}(:,7)];
aicc_rl = [prm_rl{1}(:,7) prm_rl{2}(:,7) prm_rl{3}(:,7) prm_rl{4}(:,7)];
aicc_1bl = [prm_1bl{1}(:,7) prm_1bl{2}(:,7) prm_1bl{3}(:,7) prm_1bl{4}(:,7)];
aicc_2bl = [prm_2bl{1}(:,7) prm_2bl{2}(:,7) prm_2bl{3}(:,7) prm_2bl{4}(:,7)];

T = [];
for ib = 1:4
    AICCs = [aicc_biasrand(:,ib) aicc_rl(:,ib) aicc_1bl(:,ib) aicc_2bl(:,ib)];

    % AICCs = [randn(100,1)*1 randn(100,1)*10 - 1];
    % [mean(AICCs); std(AICCs);]
    lme = -AICCs/2; % log model evidence
    [alpha,exp_r,xp,pxp,bor] = spm_BMS(lme);
    % lme is log model evidence. AIC/BIC = -2*LogLikelihood + penalty term. 
    % if we ignore the penalty term, 
    % AIC/BIC = -2*LogLikelihood. <=> -1/2 * AIC/BIC = LogLikelihood
    % thus adding -1/2 to AIC scores before entering the values to a group level
    % baysian analysis is correct. 

    dAICCs = bsxfun(@minus, AICCs, min(AICCs,[],2));
    sum(dAICCs)
    sumAICC = sum(AICCs);
    dsumAICC = bsxfun(@minus, sumAICC, min(sumAICC,[],2));
    mer = exp(-dsumAICC/2); % model evidence ratio
    T(:,:,ib) = [mer', xp', pxp'];

    Pxp(ib,:) = pxp;
end
T = table(T(:,:,1),T(:,:,2),T(:,:,3),T(:,:,4),...,
         'VariableNames',{'Baseline: MER, EP, PEP','Block1: MER, EP, PEP','Block2: MER, EP, PEP','Block3: MER, EP, PEP'}); 
% Columus: Model Evidence Ratio, Exceedance Probabilities, Protected Exceedance Probabilities
% Rows: stochastis model, RL, 1BL, 2BL.


cl = [c1; c2; c3; c4];
figure; 
for ib = 1:4 
subplot(1,4,ib); hold on 
bar(1:4, Pxp(ib,:)*100, wd, 'FaceColor',cl(ib,:), 'linewidth',lw);

xlim([0.25 4.7]); xticks(1:4); xticklabels({'Rand','RL','1BL','2BL'});
ylim([0 100]); yticks(0:25:100); ylabel('Exceedance probablity');
myfigAI2(10.5,0.04);

end

myfigAI2(10.5,0.04,900,175);

%% Supplementary Figure 2

figure; ii = 0;
for model = 1:4 
    if model == 1 
        prm = prm_bias;
    elseif model == 2
        prm = prm_rl;
    elseif model == 3
        prm = prm_1bl;
    else 
        prm = prm_2bl;
    end

for j = 1:3
    if j == 1        
        Prm = [prm{1}(:,1) prm{2}(:,1) prm{3}(:,1) prm{4}(:,1)]; % alpha
        yl = 'Learning rate';
        bin = 0:0.1:1; xt = 0:0.2:1;
    elseif j == 2
        Prm = [prm{1}(:,2) prm{2}(:,2) prm{3}(:,2) prm{4}(:,2)]; % uncertainty
        yl = 'Stochasticity';
        bin = 0:2:20; xt = 0:4:20;
    elseif j == 3
        Prm = [prm{1}(:,3) prm{2}(:,3) prm{3}(:,3) prm{4}(:,3)]; % preference
        yl = 'Temporal discouting';
        bin = 0:0.025:0.2; xt = 0:0.05:0.2;
    end
    c1 = [.75 .75 .75]; c2 = [1 0.85 0]; c3 = [1 0.2 0]; c4 = [0.65 0 0];    
    lw = 0.75; wd = 0.7; xl = {'BL','B1','B2','B3'}; x1 = 1:4;

    ii = ii+1; subplot(4,3,ii); hold on
    bplot(Prm(:,1), 1,'mean','nooutliers','linewidth',lw,'width',wd,'color','k','FaceColor',c1,'box',25,'whisker',2.5);
    bplot(Prm(:,2), 2,'mean','nooutliers','linewidth',lw,'width',wd,'color','k','FaceColor',c2,'box',25,'whisker',2.5);
    bplot(Prm(:,3), 3,'mean','nooutliers','linewidth',lw,'width',wd,'color','k','FaceColor',c3,'box',25,'whisker',2.5);
    bplot(Prm(:,4), 4,'mean','nooutliers','linewidth',lw,'width',wd,'color','k','FaceColor',c4,'box',25,'whisker',2.5);

    ylim([xt(1) xt(end)]); yticks(xt); xticks(1:4); xlim([0 5]); xticklabels({'BL','B1','B2','B3'});

    myfigAI2(9);
end
end
myfigAI2(9,[],900,750);
f = gcf;
exportgraphics(f,'barchart.png','Resolution',1200)


