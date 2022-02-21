function [S, drift_rate] = Asset_score(asset_path)
%ASSET_SCORE Asset Score S = d * d'
% read data
drift = asset_path(:,2);

% time_period = 30 days
% time_period = asset_path(length(asset_path)/2,4) - asset_path(length(asset_path)/2,1);

% drift rate
FD_orders = 10;
drift_rate = zeros(FD_orders, length(drift));
drift_rate(1) = 0;

for i = 2:length(drift_rate)
    % FD Order
    for j = 1:FD_orders
    drift_rate(j,i) = First_deriv_back_FD(drift(max(i-j,1):i), 1);
    end
end

% score with first order FD
S = abs(drift) .* drift_rate(1, :)';
end

