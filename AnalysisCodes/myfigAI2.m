function [] = myfigAI2(fs,tl,x,y)
    box off; 
    if nargin == 0
        fs = 12; tl = 0.04;  
    elseif nargin == 1
        fs = fs; tl = 0.04; 
    elseif nargin == 2
        fs = fs; tl = tl;
    else
        fs = fs; tl = tl;
        set(gcf, 'Position', [50 50 x y]);              
    end
    
    set(gca, 'Fontname', 'Arial Regular', 'Fontsize', fs, 'linewidth', 1.25,'TickLength',[tl tl+0.015]);       
    
end

