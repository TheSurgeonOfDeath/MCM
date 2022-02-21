function [Sg, Sb, Nb] = Prepare_data()
%PREPARE_DATA Prepare data to find optimal proportions
% read data

bitcoin_path = import_file_as_matrix("bitcoin_path.csv");
gold_path = import_file_as_matrix("gold_path.csv");
gold = readtable(pwd + "/../gold.csv");

% Asset scores
[Sb, ~] = Asset_score(bitcoin_path);
[Sg, ~] = Asset_score(gold_path);

% add nans for market closed
Sg = [0, 0, Sg, 0]; % add first two and last 2 points
for i = 1:height(gold)
    % use cleaned gold data as reference for closed market
    if isnan(table2array(gold(i,2)))
        Sg = [Sg(1:i-1), nan, Sg(i:end)];
    end
end
Sg = Sg(3:end-1);
Sg(1) = nan;

% Can't calculate proportions on first day because Sg is nan
Sg = Sg(2:end);
Sb = Sb(2:end);



% Normalised bitcoin score (independent of Sg)
Nb = Normalised_score(Sb);
end

