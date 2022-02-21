function priceB_fut = Remove_extremes(priceB_fut, tolerance)
for i = 2:length(priceB_fut)
    % when predicted price is infinity
    if (priceB_fut(i) == 0) % || priceB_fut(i) > tolerance * priceB_fut(i-1)
        % use previous price
        priceB_fut(i) = priceB_fut(i-1);
    end
end
end

