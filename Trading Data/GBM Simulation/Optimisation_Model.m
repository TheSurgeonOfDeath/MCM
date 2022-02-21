% read data
bitcoin_path = import_file_as_matrix("bitcoin_path_noinf_2.csv");
gold_path = import_file_as_matrix("gold_path.csv");
gold = readtable(pwd + "/../gold.csv");

% Prelimary gold and bitcoin scores (cleaned)
[Sg, Sb] = Prelim_scores(gold_path, gold, bitcoin_path);

% Optimal proportions
[Pc, Pg, Pb] = Optimal_Proportions(Sg, Sb);

% check proportions add to 1
P1 = [Pc, Pg, Pb];
P1_sum = Pc + Pg + Pb;
for i = 1:length(P1_sum)
    if abs(P1_sum - 1) > 0.0001
        disp(i);
    end
end