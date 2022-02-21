function [Pc, Pg, Pb] = Optimal_Proportions(Sg, Sb)
% Prepare data
% [Sg, Sb] = Prepare_data();

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
        Sg_guess = Sg(j);
        if abs(Sg(j)) < 1E-7
            Sg_guess = 1E-7;
        end
        Sg(i) = Sg_numerical(Pg(i), Sb(i), Sg_guess, epsilon);
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
end