% read data
bitcoin = importfile("bitcoin.csv");
gold = importfile("gold.csv");
bitcoin_price = bitcoin{:,2};
gold_price = gold{:,2};

% Calculate price change per day
bitcoin_price_change = zeros(1,length(gold_price)-1);
gold_price_change = zeros(1,length(gold_price)-1);
for i = 1:length(gold_price)-1
    gold_price_change(i) = gold_price(i+1) / gold_price(i);
    bitcoin_price_change(i) = bitcoin_price(i+1) / bitcoin_price(i);
end

% Plot
hold on;
plot(gold_price_change);
plot(bitcoin_price_change);
legend;
hold off





    