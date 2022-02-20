% read data
bitcoin_path = import_file_as_matrix("bitcoin_path.csv");
gold_path = import_file_as_matrix("gold_path.csv");
gold = readtable(pwd + "/../gold.csv");

% Asset scores
[Sb, db_rate] = Asset_score(bitcoin_path);
[Sg, dg_rate] = Asset_score(gold_path);

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

% Normalised bitcoin


% Cash score
Sc = -2 .* Sg .* Sb / (Sg + Sb);


% Normalised scores
% S = [Sc, Sg, Sb];
% N = Normalised_score(S);

% Optimal holding proportion