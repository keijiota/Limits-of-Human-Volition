% Copyright (C) Keiji Ota 2023
% Email: k.ota@ucl.ac.uk or k.ota@qmul.ac.uk
% Edited: 2023-11-18 

function [d_kl_full] = KLd_full(CP,Phistory,Q,C)
d_kl_full = 0;
if size(CP,3)==1
for ic = 1:C
    dkl_each = KLd(CP(:,ic)',Q);
    d_kl_full = d_kl_full + (Phistory(ic) * dkl_each);
end

elseif size(CP,3)==2
for wl = 1:2
   for ic = 1:C
      dkl_each = KLd(CP(:,ic,wl)',Q);
      d_kl_full = d_kl_full + (Phistory(wl,ic) * dkl_each);
   end
end
end
end
