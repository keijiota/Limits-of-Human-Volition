clear; close all;
% Copyright (C) Keiji Ota 2023
% Email: k.ota@ucl.ac.uk or k.ota@qmul.ac.uk
% Edited: 2023-11-18 


%% loading data

load('data_structure');
subN = size(dat.wt,1); C = 3;
q = [1/3 1/3 1/3]; dkl_maxp = KLd([0 1 0],q) ;

%%
for ib = 1:4 % [baseline, block 1, block 2, block 3]
    for subi = 1:subN
        str = dat.nTr(ib,subi)+1; % the trial number of the beggining of each block
        etr = dat.nTr(ib+1,subi); % the trial number of the end of each block
        data = [dat.wtbin{subi}(str:etr), dat.point2{subi}(str:etr)];
        % [wtbin: a chosen interval of wait time, point2: -1 for loss, 0 for win]

        % computing the choice bias score
        p = Entropy1(data(:,1),C);  % the probabilities of selecting early, middle and late intervals
        dklov{ib}.p2q(subi,1) = KLd(p,q); % a measure of choice bias:
        % Kullback-Leibler divergence between the observed choice probabilities and the probabilities that an agent who does not have a choice bias.

        % computing the transition bias score
        [Pt1,CP,Phistory] = Entropy2(data(:,1),C);
        dklov{ib}.pt2p(subi,1) = KLd_full(CP,Phistory,Phistory,C);


        % computing the reinforcement bias score
        transition = [data(1:end-1,1), data(1:end-1,2), data(2:end,1)];
        tmp = transition(:,2)==-1;
        pLoss = Entropy1(transition(tmp,3),C); % P of [E,M,L] given loss
        tmp = transition(:,2)==0;
        pWin = Entropy1(transition(tmp,3),C);
        [CPwl,Phistorywl,Phistorywl2] = EntropyWL2(data,C);
        CPLoss = CPwl(:,:,1); PhistoryLoss = Phistorywl(1,:);
        CPWin  = CPwl(:,:,2); PhistoryWin = Phistorywl(2,:);

        dklpl{ib}.pt2q(subi,1) = KLd_full(CPLoss,PhistoryLoss,q,C);

        dklpw{ib}.pt2q(subi,1)  = KLd_full(CPWin,PhistoryWin,q,C);

        dklpwl{ib}.pt2pt(subi,1) = KLd_full2(CPwl,Phistorywl2,CP,C);
    end
end

%%

XX = [dklov{1}.p2q,dklov{2}.p2q,dklov{3}.p2q,dklov{4}.p2q,...,
    dklov{1}.pt2p,dklov{2}.pt2p,dklov{3}.pt2p,dklov{4}.pt2p,...,
    dklpwl{1}.pt2pt,dklpwl{2}.pt2pt,dklpwl{3}.pt2pt,dklpwl{4}.pt2pt,...,
    dklpw{1}.pt2q,dklpw{2}.pt2q,dklpw{3}.pt2q,dklpw{4}.pt2q,...,
    dklpl{1}.pt2q,dklpl{2}.pt2q,dklpl{3}.pt2q,dklpl{4}.pt2q];

T = table(XX(:,1),XX(:,2),XX(:,3),XX(:,4),XX(:,5),XX(:,6),XX(:,7),XX(:,8),XX(:,9),XX(:,10),...,
    XX(:,11),XX(:,12),XX(:,13),XX(:,14),XX(:,15),XX(:,16),XX(:,17),XX(:,18),XX(:,19),XX(:,20), ...,
    'VariableNames',{'Ch0','Ch1','Ch2','Ch3','Sq0','Sq1','Sq2','Sq3',...,
    'Rf0','Rf1','Rf2','Rf3','WS0','WS1','WS2','WS3','LS0','LS1','LS2','LS3',...
    }); % to 1/3, to ch, to seq respectively

% save dat_BiasScore dklov dklpwl dklpw dklpl subN score T1 T2

%% Figure 3 D, E, F
close all;
c1 = [.75 .75 .75]; c2 = [1 0.85 0]; c3 = [1 0.2 0]; c4 = [0.65 0 0];
lw = 0.75; wd = 0.8; xl = {'BL','B1','B2','B3'}; x1 = 1:4;

figure;
subplot(1,3,1); hold on
bplot(T.Ch0, 1,'nomean','linewidth',lw,'width',wd,'color','k','FaceColor',c1,'box',25,'whisker',2.5);
bplot(T.Ch1, 2,'nomean','linewidth',lw,'width',wd,'color','k','FaceColor',c2,'box',25,'whisker',2.5);
plot(0+rand(subN,1)*0.5,T.Ch0,'k.','MarkerSize',4);
plot(2.5+rand(subN,1)*0.5,T.Ch1,'k.','MarkerSize',4);
xlim([-0.25 3.25]); xticks(1:2); xticklabels(xl(1:2)); ylabel('Choice bias');
ylim([-0.1 1.65]); yticks(0:0.5:1.6);
myfigAI([],[],10.5);

subplot(1,3,2); hold on
bplot(T.Sq1, 1,'nomean','linewidth',lw,'width',wd,'color','k','FaceColor',c2,'box',25,'whisker',2.5);
bplot(T.Sq2, 2,'nomean','linewidth',lw,'width',wd,'color','k','FaceColor',c3,'box',25,'whisker',2.5);
plot(0+rand(subN,1)*0.5,T.Sq1,'k.','MarkerSize',4);
plot(2.5+rand(subN,1)*0.5,T.Sq2,'k.','MarkerSize',4);
xlim([-0.25 3.25]); xticks(1:2); xticklabels(xl(2:3)); ylabel('Sequentail bias');
ylim([-0.025 0.5]); yticks(0:0.1:0.6); myfigAI([],[],10.5);

subplot(1,3,3); hold on
bplot(T.Rf2, 1,'nomean','linewidth',lw,'width',wd-0.05,'color','k','FaceColor',c3,'box',25,'whisker',2.5);
bplot(T.Rf3, 2,'nomean','linewidth',lw,'width',wd-0.05,'color','k','FaceColor',c4,'box',25,'whisker',2.5);
plot(0+rand(subN,1)*0.5,T.Rf2,'k.','MarkerSize',4);
plot(2.5+rand(subN,1)*0.5,T.Rf3,'k.','MarkerSize',4);
xlim([-0.25 3.25]); xticks(1:2); xticklabels(xl(3:4)); ylabel('Reinforcement bias');
ylim([-0.025 0.5]); yticks(0:0.1:0.6);
myfigAI(875,210,10.5);

%% SFigure 1B

figure; wd = wd-0.05;
subplot(1,2,1); hold on
bplot(T.WS2, 1,'nomean','linewidth',lw,'width',wd,'color','k','FaceColor',c3,'box',25,'whisker',2.5);
bplot(T.WS3, 2,'nomean','linewidth',lw,'width',wd,'color','k','FaceColor',c4,'box',25,'whisker',2.5);
plot(0+rand(subN,1)*0.5,T.WS2,'k.','MarkerSize',4);
plot(2.5+rand(subN,1)*0.5,T.WS3,'k.','MarkerSize',4);
xlim([-0.25 3.25]); xticks(1:2); xticklabels(xl(3:4)); ylabel('Positive reinf bias');
ylim([-0.05 1.05]); yticks(0:0.2:1.1);
myfigAI([],[],10.5);

subplot(1,2,2); hold on
bplot(T.LS2, 1,'nomean','linewidth',lw,'width',wd,'color','k','FaceColor',c3,'box',25,'whisker',2.5);
bplot(T.LS3, 2,'nomean','linewidth',lw,'width',wd,'color','k','FaceColor',c4,'box',25,'whisker',2.5);
plot(0+rand(subN,1)*0.5,T.LS2,'k.','MarkerSize',4);
plot(2.5+rand(subN,1)*0.5,T.LS3,'k.','MarkerSize',4);
xlim([-0.25 3.25]); xticks(1:2); xticklabels(xl(3:4)); ylabel('Negative reinf bias');
ylim([-0.05 1.05]); yticks(0:0.2:1.1);
myfigAI(575,210,10.5);

%% statistical tests for a planned comparison of bias scores
stat = []; ntest = 5;
for itest = 1:ntest
    if itest == 1
        x1 = T.Ch0; x2 = T.Ch1;
    elseif itest == 2
        x1 = T.Sq1; x2 = T.Sq2;
    elseif itest == 3
        x1 = T.Rf2; x2 = T.Rf3;
    elseif itest == 4
        x1 = T.WS2; x2 = T.WS3;
    elseif itest == 5
        x1 = T.LS2; x2 = T.LS3;
    end

    mdn1 = median(x1); mdn2 = median(x2);
    [p,h,stats] = signrank(x1,x2,'alpha',0.05/ntest) ;
    stat = [stat; mdn1, mdn2, p, h, stats.zval, stats.signedrank];
end

%% Figure 4

figure; stat = [];
for i = 1:4
    subplot(2,2,i); hold on ;
    if i == 1
        XX = [T.Ch1-T.Ch0 T.Sq2-T.Sq1 T.Rf3-T.Rf2]; xl = {'Choice d(B1-B0)','Sequence d(B2-B1)','Reinf d(B3-B2)'};
        x = XX(:,1); y = XX(:,2);
    elseif i == 2
        x = XX(:,1); y = XX(:,3);
    elseif i == 3
        x = XX(:,2); y = XX(:,3);
    elseif i == 4
        XX = [T.WS3-T.WS2 T.LS3-T.LS2]; xl = {'+ve reinf d(B3-B2)', '-ve reinf d(B3-B2)'};
        x = XX(:,1); y = XX(:,2);
    end

    xx = sort(x); xx = [xx(1)-1 xx(end)+1];[p] = polyfit(x,y,1); pv = polyval(p,xx);
    plot(xx,pv,'r-','LineWidth',1);

    plot(x,y,'ko','MarkerEdgeColor',[.2 .2 .2],'MarkerSize',4); hold on
    [r pval rlo rup] = corrcoef(x,y);
    stat = [stat; r(1,2) pval(1,2) rlo(1,2) rup(1,2)];
    axis square;

    if i == 1
        xlim([-1.7 -0.3]); xticks(-1.5:0.5:1);
        ylim([-0.6 0.4]); yticks(-0.6:0.3:0.4);
        xlabel(xl(1)); ylabel(xl(2));
    elseif i == 2
        xlim([-1.7 -0.3]); xticks(-1.5:0.5:1);
        ylim([-0.4 0.3]); yticks(-0.6:0.2:0.4);
        xlabel(xl(1)); ylabel(xl(3));
    elseif i == 3
        xlim([-0.6 0.4]); xticks(-0.6:0.3:0.4);
        ylim([-0.4 0.3]); yticks(-0.6:0.2:0.4);
        xlabel(xl(2)); ylabel(xl(3));
    elseif i == 4
        xlim([-0.8 0.8]); xticks(-0.8:0.4:0.8);
        ylim([-1 0.8]); yticks(-1:0.5:0.8);
        xlabel(xl(1)); ylabel(xl(2));
    end
    myfigAI([],[],10);
end
myfigAI(500,500,10);
