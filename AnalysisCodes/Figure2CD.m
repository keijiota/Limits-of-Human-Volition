clear; close all;

%%
load('data_structure');
subN = size(dat.wt,1); C = 3; q = [1/3 1/3 1/3]; 

%%
for ib = 1:4 % [baseline, block 1, block 2, block 3]
    for subi = 1:subN
        str = dat.nTr(ib,subi)+1; % the trial number of the beggining of each block
        etr = dat.nTr(ib+1,subi); % the trial number of the end of each block
        rtdata = [dat.wtbin{subi}(str:etr), dat.point2{subi}(str:etr)];
        % [wtbin: a chosen interval of wait time, point2: -1 for loss, 0 for win]

        score{ib}(subi,1) = (size(rtdata,1) + sum(rtdata(:,2))) / size(rtdata,1) * 100 ;  
        p = Entropy1(rtdata(:,1),C); % the probabilities of selecting early, middle and late intervals
        dklov{ib}.p2q(subi,1) = KLd(p,q);
        % a measure of choice bias: 
        % Kullback-Leibler divergence between the observed choice probabilities and the probabilities that an agent who does not have a choice bias.       
    end
end


%% Figure 2C
close all; 
c1 = [.75 .75 .75]; c2 = [1 0.85 0]; c3 = [1 0.2 0]; c4 = [0.65 0 0]; 
lw = 0.75; wd = 0.8; xl = {'BL','B1','B2','B3'}; x1 = 1:4;

figure; hold on 
bplot(score{1}, 1,'nomean','linewidth',lw,'width',wd,'color','k','FaceColor',c1,'box',25,'whisker',2.5);
bplot(score{2}, 2,'nomean','linewidth',lw,'width',wd,'color','k','FaceColor',c2,'box',25,'whisker',2.5);
bplot(score{3}, 3,'nomean','linewidth',lw,'width',wd,'color','k','FaceColor',c3,'box',25,'whisker',2.5);
bplot(score{4}, 4,'nomean','linewidth',lw,'width',wd,'color','k','FaceColor',c4,'box',25,'whisker',2.5);
xlim([0.25 4.5]); xticks(1:4); xticklabels(xl); ylabel('Success rate');
lineplot(66.6, 'h','k--');
ylim([38 102]); yticks(20:10:100);
myfigAI(400,300,10.5);

stat = []; ntest = 3;
for itest = 1:ntest 
    if itest == 1
       x1 = score{1}; x2 = score{2};
    elseif itest == 2
       x1 = score{2}; x2 = score{3};
    elseif itest == 3
       x1 = score{3}; x2 = score{4};        
    end

mdn1 = median(x1); mdn2 = median(x2); 
[p,h,stats] = signrank(x1,x2,'alpha',0.05/ntest) ;
stat = [stat; mdn1, mdn2, p, h, stats.zval, stats.signedrank];
end


%% Figure 2D
ib = 2; 
[sdklchoice, idx] = sort(dklov{ib}.p2q,'descend'); % sorted by a choice bias on B1
tmax = 4.5; 

figure; RT = [];
subplot(1,2,1); hold on ; yyaxis right; 
ib = 1; 
for subi = 1:subN
    str = dat.nTr(ib,idx(subi))+1; etr = dat.nTr(ib+1,idx(subi));
    rtdata = [dat.wt{idx(subi)}(str:etr)]; 
    for j = 1:length(rtdata)
        plot(rtdata(j,1), 1*subi, 'k|','MarkerSize',1);
    end
    RT = [RT; rtdata];
end
set(gca,'YColor','k');
yticks(0:25:150); ylim([-2.5 subN+2.5]); xlim([0 4.65]); xticks(0:1.5:tmax);
set(gca, 'Fontname', 'Arial Regular', 'Fontsize', 9, 'linewidth', 1,'TickLength',[0.01 0]);
yyaxis left; set(gca,'YColor','none'); box off;
[mean(RT) std(RT)]

subplot(1,2,2); hold on ; yyaxis right; 
ib = 2; 
for subi = 1:subN
    str = dat.nTr(ib,idx(subi))+1; etr = dat.nTr(ib+1,idx(subi));
    rtdata = [dat.wt{idx(subi)}(str:etr)]; 
    for j = 1:length(rtdata)
        plot(rtdata(j,1), 1*subi, 'k|','MarkerSize',1);
    end
end
set(gca,'YColor','k');
yticks(0:25:150); ylim([-2.5 subN+2.5]); xlim([0 4.65]); xticks(0:1.5:tmax);
set(gca, 'Fontname', 'Arial Regular', 'Fontsize', 9, 'linewidth', 1,'TickLength',[0.01 0]);
yyaxis left; set(gca,'YColor','none'); box off;

% set(gcf, 'Position', [50 50 700 500]);      
% exportgraphics(gcf,'rawrt.png','Resolution',1100);


