function [CP,Phistory,Phistory2] = EntropyWL2(dat,C)

wtbin = dat(:,1); pt    = dat(:,2);
transition = [wtbin(1:end-1), pt(1:end-1), wtbin(2:end)];
for ib1 = 1:C
    tmp1 = transition(:,1) == ib1; 
    for rw = [0 -1]
        tmp2 = transition(:,2) == rw;
        for ib2 = 1:C
            tmp3 = transition(:,end) == ib2;
            if sum(tmp1&tmp2&tmp3) == 0
                CP(ib2, ib1, rw+2) = 0 ;
            else
                CP(ib2, ib1, rw+2) = sum(tmp1&tmp2&tmp3) / sum(tmp1&tmp2);
                % conditional probability of [E,M,L] given the previous choice and outcome
            end
            % cp(rw+2,ib2) = sum(tmp2&tmp3) / sum(tmp2);
            % this is the conditional probability of [E,M,L] given the previous outcome
        end
        %[lose 1 2 3; win 1 2 3]
        if sum(tmp1&tmp2) == 0 
            Phistory(rw+2,ib1) = 0;
        else        
            Phistory(rw+2,ib1) = sum(tmp1&tmp2) / sum(tmp2);
        end
        % this is the joint probability of [E,M,L] and -ve or +ve outcome. E.g., P(E,Loss)
        % this joint probability should be used for weighting KLd
        % as the conditional probaility of [E,M,L] (eg, P(E|E,loss)) is conditioned on/after this choice and outcome. 
        % Phistory is the overall choice probabilities, weighted sum of choice prob. post win and choice prob, post loss with weights of proportion of winning/loosing
        Phistory2(rw+2,ib1) = sum(tmp1&tmp2) / size(transition,1);
        % this is also joint probability. Sum of 6 cells is 1
    end
end

end
%L [1->1,2->1,3->1;
%  1->2,2->2,3->2;
%  1->3,2->3,3->3]
%W [1->1,2->1,3->1;
%  1->2,2->2,3->2;
%  1->3,2->3,3->3]


