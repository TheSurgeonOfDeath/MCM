% read data
gold_path = import_file_as_matrix("gold_path.csv");
% prev_days = gold_path(:,4) - gold_path(:,1);
% prev_days(length(prev_days)-30:end) = 30;
drift = gold_path(:,2);

% time_period = 30 days
time_period = gold_path(length(gold_path)/2,4) - gold_path(length(gold_path)/2,1);

% drift rate
drift_rate = zeros(2, length(drift));
drift_rate(1) = 0;

for i = 2:length(drift_rate)
%     if i < time_period
%         num_pts = i;
%     else
%         num_pts = time_period;
%     end
    
%     drift_rate(i) = First_deriv_back_FD(drift(i-num_pts+1:i), 1);
    
    % first order
    drift_rate(1,i) = First_deriv_back_FD(drift(i-1:i), 1);
    % second order
    drift_rate(2,i) = First_deriv_back_FD(drift(max(i-2,1):i), 1);
end

% score with first order FD
S = abs(drift) .* drift_rate(1, :);
