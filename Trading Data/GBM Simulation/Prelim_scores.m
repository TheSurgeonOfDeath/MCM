function [Sg, Sb] = Prelim_scores(gold_path, gold, bitcoin_path)
%PRELIM_SCORES Preliminary scores for gold and bitcoin

% Asset scores
[Sb, ~] = Asset_score(bitcoin_path);
[Sg, ~] = Asset_score(gold_path);

% add nans for market closed
Sg = [0; 0; Sg; 0]; % add first two and last 2 points
for i = 1:height(gold)
    % use cleaned gold data as reference for closed market
    if isnan(table2array(gold(i,2)))
        Sg = [Sg(1:i-1); nan; Sg(i:end)];
    end
end
Sg = Sg(3:end-1);

% Can't calculate proportions on first day because Sg is nan
Sg = Sg(2:end);
Sb = Sb(2:end);
end

