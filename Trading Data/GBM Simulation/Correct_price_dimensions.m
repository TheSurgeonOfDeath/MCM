function [Fg, Fb] = Correct_price_dimensions(Fg,Fb)
%CORRECT_DIMENSIONS aligns gold and bitcoin data

gold = readtable(pwd + "/../gold.csv");

Fg = [0; 0; Fg; 0]; % add first two and last 2 points
for i = 1:height(gold)
    % use cleaned gold data as reference for closed market
    if isnan(table2array(gold(i,2)))
        Fg = [Fg(1:i-1); nan; Fg(i:end)];
    end
end
Fg = Fg(3:end-1);

% Can't calculate proportions on first day because Sg is nan
Fg = Fg(2:end);
Fb = Fb(2:end);
end

