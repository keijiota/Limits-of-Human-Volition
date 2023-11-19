% Copyright (C) Keiji Ota 2023
% Email: k.ota@ucl.ac.uk or k.ota@qmul.ac.uk
% Edited: 2023-11-18 

function [d_kl_full] = KLd_full2(CPwl,Phistory,CP,C)
d_kl_full = 0;
if size(CPwl,3)==1
    for ic = 1:C
        dkl_each = KLd(CPwl(:,ic)',CP(:,ic)');
        d_kl_full = d_kl_full + (Phistory(ic) * dkl_each);
    end
elseif size(CPwl,3)==2
    for wl = 1:2
        for ic = 1:C
            dkl_each = KLd(CPwl(:,ic,wl)',CP(:,ic)');
            d_kl_full = d_kl_full + (Phistory(wl,ic) * dkl_each);
        end
    end
end
end
