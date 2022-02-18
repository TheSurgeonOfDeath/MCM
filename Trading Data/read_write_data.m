% read data
bitcoin = importfile("BCHAIN-MKPRU.csv");
gold = importfile("LBMA-GOLD.csv");
gold_clean = clean_gold_data(gold);

% write data
writetable(bitcoin, "bitcoin.csv");
writetable(gold_clean, "gold.csv");
writetable(gold, "gold_raw.csv");