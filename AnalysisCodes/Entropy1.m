function [P, entropy1, maxentropy1] = Entropy1(dat,c)
% occurence probability, entropy of c^1
for ic = 1:c
  wtbin = dat;
  P(ic) = sum(wtbin == ic) / length(wtbin);
end
entropy1 = - nansum(P .* log2(P));
p = ones(1,c)*1/(c);
maxentropy1 = - nansum(p .* log2(p));

end
