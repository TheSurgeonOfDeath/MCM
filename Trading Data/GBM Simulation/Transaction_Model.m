% Initial Funds
F_init = [1000, 0, 0];
P_init = F_cur./sum(F_init);

% Day 4 model starts

% read data
bitcoin_path = import_file_as_matrix("bitcoin_path_noinf_2.csv");
gold_path = import_file_as_matrix("gold_path.csv");
gold = readtable(pwd + "/../gold.csv");
bitcoin = readtable(pwd + "/../bitcoin.csv");

% Prelimary gold and bitcoin scores (cleaned)
[Sg, Sb] = Prelim_scores(gold_path, gold, bitcoin_path);

% Optimal proportions
P_opt = zeros(1,3);
[P_opt(1), P_opt(2), P_opt(3)] = Optimal_Proportions(Sg, Sb);
P_opt = [zeros(3,3); P_opt]; % model starts at day 4

% Investment on Day 1

% Current proportions
P_cur = zeros(size(P_opt));

% Actual prices
priceB_cur = table2array(bitcoin(:,2));
priceG_cur = table2array(gold(:,2));

% Predicted future prices
priceB_fut = bitcoin_path(2:end,3); % start at day 4
priceG_fut = gold_path(:,3);

% Clean future prices
[priceG_fut, priceB_fut] = Correct_price_dimensions(priceG_fut,priceB_fut);
for i = 1:length(priceB_fut)
    % when predicted price is infinity
    if priceB_fut(i) == 0
        % use previous price
        priceB_fut(i) = priceB_fut(i-1);
    end
end






