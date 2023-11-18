clear; close all;
% Credit: Keiji Ota (email: k.ota@ucl.ac.uk or k.ota@qmul.ac.uk)
% Date: 2023-11-18 (version 1)

%% loading data
load('data_structure');
subN = size(dat.wt,1); c = 1:3; C = 3;

%%
mtx = [];    
for ib = 2:4 % exclude the baseline block
for subi = 1:subN
        str = dat.nTr(ib,subi)+1; etr = dat.nTr(ib+1,subi);
        data = [dat.wtbin{subi}(str:etr), dat.bet{subi}(str:etr), dat.point2{subi}(str:etr)];
        data(:,3) = data(:,3)+1; len = length(data);
        if ib == 1
            data(15,2) = 3; data(16,2) = 2; 
        end

        y = data(6:end,1); % next choice
        own1 = data(5:end-1,1); opt1 = data(5:end-1,2);
        own2 = data(4:end-2,1); opt2 = data(4:end-2,2);
        own3 = data(3:end-3,1); opt3 = data(3:end-3,2);
        own4 = data(2:end-4,1); opt4 = data(2:end-4,2);
        own5 = data(1:end-5,1); opt5 = data(1:end-5,2);
        
        X = [own1 opt1 own2 opt2 own3 opt3 own4 opt4 own5 opt5];

%         [B,dev,stats] = mnrfit(X,y,'model','ordinal');

        %----
        n = size(X,1);
        mtx = [mtx; ones(n,1)*subi, ones(n,1)*ib, y, X] ;
end
end

X = mtx(:,4:end); y = mtx(:,3);
[B,dev,stats] = mnrfit(X,y,'model','ordinal');
Beta = B(3:end); Stats = stats.p(3:end); SE = stats.se(3:end);

T = mtx;
T = table(T(:,1),T(:,2),T(:,3),T(:,4),T(:,5),T(:,6),T(:,7),T(:,8),T(:,9),T(:,10),T(:,11),T(:,12),T(:,13),...,
    'VariableNames',{'id','ib','resp','own1','opt1','own2','opt2','own3','opt3','own4','opt4','own5','opt5'});
writetable(T, strcat('autoreg_data_b1-3','.xlsx')) ;

% .xlsx file will go to R code for a further analysis on a sequential dependence 



