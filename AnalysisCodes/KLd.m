% Credit: Keiji Ota (email: k.ota@ucl.ac.uk or k.ota@qmul.ac.uk)
% Date: 2023-11-18 (version 1)

function d_kl = KLd(P,Q)
  % P and Q: one by x vector
  eps = 10^(-10);
  d_kl = sum(P .* log2((P+eps) ./ (Q+eps))) ;
end

