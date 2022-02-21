function m  = max_ratio(x)
%MAX_DIFF find max difference between two days
m = 1;
for i = 2:length(x)
    if  m < x(i) / x(i-1)
        m = x(i) / x(i-1);
    end
end
end

