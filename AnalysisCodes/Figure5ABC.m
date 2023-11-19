clear; close all;

% Copyright (C) Keiji Ota 2023
% Email: k.ota@ucl.ac.uk or k.ota@qmul.ac.uk
% Edited: 2023-11-18 

%% 
load autoreg_model_prm.mat
T13 = readtable('clmm_autoreg_data_b1-3.xlsx');
% this is the output of lagged regression analysis on R code
nlag = 5;

%% Figure 5A&B
cl = [0.5 0.5 0.5; 0 0.65 1; 0 1 0.8; ];
c1 = [.75 .75 .75]; c2 = [1 0.85 0]; c3 = [1 0.2 0]; c4 = [0.65 0 0];
lw = 0.75;

figure; j = 0; algo = 4;
j=j+1; subplot(2,4,j); hold on
for model = 1:3
    b = -Beta_mdl{model,algo}([1:2:end-1]); se = SE_mdl{model,algo}([1:2:end-1]);
    errorbar(1:nlag, b, 2*se, 'o-','Color',cl(model,:),'MarkerFaceColor',cl(model,:), 'linewidth',lw);
end
xlim([0.5 5.5]); xticks(1:5); ylim([-1 1]); yticks(-2:0.5:2);
ylabel('weight'); xlabel('lag'); title('own action');
yline(0,'k--');
legend({'RL','1st BL','2nd BL'});
myfigAI2(10.5);

subplot(2,4,j+4); hold on
for model = 1:3
    b = -Beta_mdl{model,algo}([2:2:end]); se = SE_mdl{model,algo}([2:2:end]);
    errorbar(1:nlag, b, 2*se, 's-','Color',cl(model,:),'MarkerFaceColor',cl(model,:), 'linewidth',lw);
end
xlim([0.5 5.5]); xticks(1:5); ylim([-1 1]); yticks(-2:0.5:2);
ylabel('weight'); xlabel('lag'); title('opponents action');
yline(0,'k--');
myfigAI2(10.5);

for ib = 2:4
    if ib == 2
        T= table(T13.Coefb1,T13.SEb1,'VariableNames',{'coef','se'}); c= c2;
    elseif ib == 3
        T= table(T13.Coefb2,T13.SEb2,'VariableNames',{'coef','se'}); c= c3;
    elseif ib == 4
        T= table(T13.Coefb3,T13.SEb3,'VariableNames',{'coef','se'}); c= c4;
    end

    j=j+1; subplot(2,4,j); hold on
    b = T.coef([1:2:end-1]); se = T.se([1:2:end-1]);
    errorbar(1:nlag, b, 2*se,'-','MarkerSize',4,'Color',c,'MarkerFaceColor',c, 'linewidth',lw, 'CapSize',10);
    xlim([0.5 5.5]); xticks(1:5); ylim([-1 1]); yticks(-2:0.5:2);
    ylabel('weight'); xlabel('lag'); title('own action');
    yline(0,'k--');
    myfigAI2(10.5);

    subplot(2,4,j+4); hold on
    b = T.coef([2:2:end]); se = T.se([2:2:end]);
    errorbar(1:nlag, b, 2*se,'-','MarkerSize',1,'Color',c,'MarkerFaceColor',c, 'linewidth',lw,'CapSize',10);

    xlim([0.5 5.5]); xticks(1:5); ylim([-1 1]); yticks(-2:0.5:2);
    ylabel('weight'); xlabel('lag'); title('opponents action');
    yline(0,'k--');
    myfigAI2(10.5);
end

myfigAI2(10.5,0.04,975,450);

%% Figure 5C
figure;
posx = [1, 2, 3]; lag = 1;
subplot(2,1,1); hold on
for ib = 2:4
    if ib == 2
        T= table(T13.Coefb1,T13.SEb1,'VariableNames',{'coef','se'}); c= c2;
    elseif ib == 3
        T= table(T13.Coefb2,T13.SEb2,'VariableNames',{'coef','se'}); c= c3;
    elseif ib == 4
        T= table(T13.Coefb3,T13.SEb3,'VariableNames',{'coef','se'}); c= c4;
    end
    bar(posx(ib-1), T.coef(lag), 'FaceColor',c, 'linewidth',1);
    errorbar(posx(ib-1), T.coef(lag), T.se(lag),'k-', 'linewidth',lw);

    xlim([0.25 3.75]); xticks(1:3); ylim([-0.8 0.5]); yticks(-2:0.25:2);
    ylabel('weight'); xlabel('blocks'); title('own action');
    yline(0,'k--');
    myfigAI2(10.5);
end

subplot(2,1,2); hold on
for ib = 2:4
    if ib == 2
        T= table(T13.Coefb1,T13.SEb1,'VariableNames',{'coef','se'}); c= c2;
    elseif ib == 3
        T= table(T13.Coefb2,T13.SEb2,'VariableNames',{'coef','se'}); c= c3;
    elseif ib == 4
        T= table(T13.Coefb3,T13.SEb3,'VariableNames',{'coef','se'}); c= c4;
    end
    bar(posx(ib-1), T.coef(lag+1), 'FaceColor',c, 'linewidth',1);
    errorbar(posx(ib-1), T.coef(lag+1), T.se(lag+1),'k-', 'linewidth',lw);

    xlim([0.25 3.75]); xticks(1:3); ylim([-0.8 0.5]); yticks(-2:0.25:2);
    ylabel('weight'); xlabel('blocks'); title('opponents action');
    yline(0,'k--');
    myfigAI2(10.5);
end
myfigAI2(10.5,0.04,225,450);



