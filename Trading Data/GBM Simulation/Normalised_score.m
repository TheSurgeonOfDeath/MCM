function N = Normalised_score(S)
%NORMALISED SCORE N = 1/(1+exp(-S))

for i = 1:length(S)
    N = 1/(1+exp(-S(i)));
end
end

