function gold_clean = clean_gold_data(gold)
dates = gold{:,1};
% gold_prices = gold{:,2};
gold_clean = gold;

% add days market is closed with empty cells
for i = length(dates):-1:2
    num_days = days(dates(i) - dates(i-1));
    if num_days > 1
        for j = 1:num_days - 1
            TempTab = table(dates(i-1)+j, NaN, 'VariableNames',{'Date','Value'});
            gold_clean = [gold_clean; TempTab];
        end
    end
end

gold_clean = sortrows(gold_clean, 1);

% Add first day when market is closed
TempTab = table(dates(1) - 1, NaN, 'VariableNames',{'Date','Value'});
gold_clean = [TempTab; gold_clean];

% plot(Gold_prices)
end