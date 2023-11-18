function [P, CP, Phistory, entropy2, maxentropy2] = Entropy2(dat,c)
% conditional probability, entropy of c^2

wtbin = dat;
transition = [wtbin(1:end-1) wtbin(2:end)];

for ib1 = 1:c
    tmp1 = transition(:,1) == ib1; 
    for ib2 = 1:c
        tmp2 = tmp1 & transition(:,2) == ib2;
        if sum(tmp2) == 0
          CP(ib2, ib1) = 0 ;
        else            
          CP(ib2, ib1) = sum(tmp2) / sum(tmp1);  % conditional probability
        end
    end
    Phistory(1,ib1) = sum(tmp1) / size(transition,1);
    % the probability of each entry, overall choice probability
    % this should be used for weighting KLd
    % as the conditional probaility of [E,M,L] (eg, P(E|E)) is conditioned on/after this choice.
end
P = CP .* Phistory ; % by chain rule
p = reshape(P,1,numel(P));
entropy2 = - nansum(p .* log2(p));
p = ones(1,c^2)*1/(c^2);
maxentropy2 = - nansum(p .* log2(p));

end
% [1->1,2->1,3->1; 
%  1->2,2->2,3->2;
%  1->3,2->3,3->3]