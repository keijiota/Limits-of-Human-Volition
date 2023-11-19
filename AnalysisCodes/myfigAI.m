% Copyright (C) Keiji Ota 2023
% Email: k.ota@ucl.ac.uk or k.ota@qmul.ac.uk
% Edited: 2023-11-18 

function [] = myfigAI(x,y,fs)
    box off; 
    if nargin == 0
        fs = 12;  
    elseif ~isempty(x)
        set(gcf, 'Position', [50 50 x y]);      
    end
    set(gca, 'Fontname', 'Arial Regular', 'Fontsize', fs, 'linewidth', 1.25,'TickLength',[0.02 0]);       
    
end

