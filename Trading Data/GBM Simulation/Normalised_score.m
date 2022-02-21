function N = Normalised_score(S)
%NORMALISED SCORE N = 1/(1+exp(-S))
N = S;
for i = 1:length(S)
%     N(i) = 1/(1+exp(-S(i)));
%     N(i) = 10/(1+exp(-S(i)));
%     N(i) = exp(S(i));
    N(i) = atan(S(i)) / pi + 1/2;
%     N(i) = 3*atan(pi/2 * S(i)) + 3*pi/2;
end
end

