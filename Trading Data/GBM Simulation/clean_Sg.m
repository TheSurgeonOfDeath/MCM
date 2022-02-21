function cleaned_Sg = clean_Sg(Sg)
%CLEAN_SG Summary of this function goes here
cleaned_Sg = [0, 0, Sg, 0]; % add first two and last 2 points
for i = 1:height(gold)
    % use cleaned gold data as reference for closed market
    if isnan(table2array(gold(i,2)))
        cleaned_Sg = [cleaned_Sg(1:i-1), nan, cleaned_Sg(i:end)];
    end
end
cleaned_Sg = cleaned_Sg(3:end-1);
cleaned_Sg(1) = nan;
end

