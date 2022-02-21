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

% Can't calculate proportions on first day because Sg is nan
Sg = Sg(2:end);
Sb = Sb(2:end);



% Normalised bitcoin score (independent of Sg)
Nb = Normalised_score(Sb);

% Calculate Optimal Proportions
Ng = zeros(size(Sg));
Sc = zeros(size(Sg));
Nc = zeros(size(Sg));
Pg = zeros(size(Sg));
Pb = zeros(size(Sg));
Pc = zeros(size(Sg));

for i = 1:length(Sg)    
    % market closed
    if isnan(Sg(i))
        % Calculate gold score when market closed to keep propotion same
        % day before market closed
        j = i;
        while isnan(Sg(j))
            j = j-1;
        end
        
        % Proportion of gold cannot change
        Pg(i) = Pg(j);
        
        % Find Sg for day such that Pg does not change (numerically) -
        % guess new score is close to old score.
        disp(i)
        epsilon = max(Sg) - min(Sg);
        Sg(i) = Sg_numerical(Pg(i), Sb(i), Sg(j), epsilon);
    end
    
    % cash score
    Sc(i) = -2 * Sg(i) * Sb(i) / (Sg(i) + Sb(i));

    % normalised score
    Ng(i) = Normalised_score(Sg(i));
    Nc(i) = Normalised_score(Sc(i));

    % optimal proportions
    scoreSum = Ng(i) + Nb(i) + Nc(i);
    Pg(i) = Ng(i) / scoreSum;
    Pb(i) = Nb(i) / scoreSum;
    Pc(i) = Nc(i) / scoreSum;
end