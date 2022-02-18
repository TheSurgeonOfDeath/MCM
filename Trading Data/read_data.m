% read data
bitcoin = importfile("BCHAIN-MKPRU.csv");
gold = importfile("LBMA-GOLD.csv");
gold_clean = clean_gold_data(gold);

% write data
writetable(bitcoin, "bitcoin.csv");
writetable(bitcoin, "gold_clean.csv");