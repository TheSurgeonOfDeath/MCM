% Initial Funds
F_init = [1000, 0, 0];
P_init = F_init./sum(F_init);
V_init = sum(F_init);

% Day 4 model starts

% read data
bitcoin_path = import_file_as_matrix("bitcoin_path_noinf_2.csv");
gold_path = import_file_as_matrix("gold_path.csv");
gold = readtable(pwd + "/../gold.csv");
bitcoin = readtable(pwd + "/../bitcoin.csv");

% Prelimary gold and bitcoin scores (cleaned)
[Sg, Sb] = Prelim_scores(gold_path, gold, bitcoin_path);

% Optimal proportions
% [Pc, Pg, Pb] = Optimal_Proportions(Sg, Sb);
P_opt = [Pc, Pg, Pb];
P_opt = [zeros(2,3); P_opt]; % model starts at day 4

% Current proportions
P_cur = zeros(size(P_opt));

% Actual prices
priceB_cur = table2array(bitcoin(2:end,2));
priceG_cur = table2array(gold(2:end,2));
for i = 1:length(priceG_cur)
    if isnan(priceG_cur(i))
        priceG_cur(i) = priceG_cur(i-1);
    end
end
A_price_cur = [ones(size(priceB_cur)), priceB_cur, priceG_cur];

% Predicted future prices
priceB_fut = bitcoin_path(:,3);
priceG_fut = gold_path(:,3);
% model start on day 4 so assume value of stock stays constant in future
% for first 3 days.
priceB_fut = [priceB_cur(1:2); priceB_fut]; 
priceG_fut = [priceG_cur(1:2); priceG_fut];

% Clean future prices
[priceG_fut, priceB_fut] = Correct_price_dimensions(priceG_fut,priceB_fut);
for i = 1:length(priceB_fut)
    % when predicted price is infinity
    if priceB_fut(i) == 0
        % use previous price
        priceB_fut(i) = priceB_fut(i-1);
    end
end
A_price_fut = [ones(size(priceB_fut)), priceB_fut, priceG_fut];

% Total funds
F = zeros(size(P_opt));

% Asset amounts
A_amount = zeros(size(P_opt));



% Investment on Day 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% P_invest = P_init; % [1, 0, 0] no blind investment
% P_invest = [0, 0.5, 0.5]; % 2 way split
P_invest = [1/3, 1/3, 1/3]; % 3 way split
F_invest = P_invest .* sum(F_init);
F(1,:) = F_invest;
A_amount(1,:) = F_invest ./ A_price_cur(1,:);
P_opt(1,:) = P_invest;
for i = 2:2
    F(i,:) = F_invest .* A_price_cur(i-1,:);
    A_amount(i,:) = A_amount(i-1,:);
    P_opt(i,:) = P_invest;
end
P_cur(1:3,:) = P_opt(1:3,:);




% Fee percent
alpha = [0,0.1,0.2];

% Error
epsilon = 0;

% Transactions
Ac = zeros(size(P_opt));
num_trans = 0;
% [C, G, B]
for i = 3:length(A_price_fut)
    % Funds today
    F(i,:) = A_amount(i-1, :) .* A_price_cur(i,:);
    
    % Current proportion
    P_cur(i,:) = P_cur(i-1,:);
    
    % Asset change
    Ac = (P_opt(i, :) ./ P_cur(i,:) - 1) .* F(i,:);
    
    % Fee on transactions
    fee = alpha .* abs(Ac);
    feeTot = sum(fee);
    
    % total current funds before and after transaction
    Vc_before = sum(F(i,:));
    Vc_after = Vc_before - feeTot;
    
    % asset amounts after transaction
    A_after = P_opt(i, :) .* Vc_after;
    
    % asset value in future
    A_val_fut = A_after ./ A_price_fut(i,:);
    
    % Portfolio value (current and future)
    Vc = Vc_before;
    Vf = sum(A_val_fut);
    
    % Make transaction?
    if(Vf - Vc > (1+epsilon)*feeTot)
        num_trans = num_trans + 1;
        P_cur(i,:) = P_opt(i,:);
        % new funds today after transaction
        F(i,:) = F(i,:) ./ (sum(F(i,:)) - feeTot) .* P_opt(i,:);
        A_amount(i,:) = F(i,:) ./ A_price_cur(i,:);
    else
%         P_cur(i,:) = P_cur(i,:); % 
        A_amount(i,:) = A_amount(i-1,:);
    end
end

% Final portfolio value 
% (previous amount * current price) - amount vector is shorter by 1 day
F_final = A_amount(end,:) .* A_price_cur(end, :);
V_final = sum(F_final);

% Comparison by investing all in bitcoin
b_price = table2array(bitcoin(:,2));
b_amount_init = 1000 / b_price(1);
b_peak_price = max(b_price);
b_value_end = b_amount_init * b_peak_price;

diff =  V_final - b_value_end;



