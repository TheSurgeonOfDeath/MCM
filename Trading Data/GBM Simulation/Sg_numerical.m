function Sg = Sg_numerical(Pf, Sb, Sg_guess, epsilon)
%SG_NUMERICAL Solves for Gold Score Sg numerically when markets are closed
%to preserve Gold Proportion Pg. 
    % Given proportion gold on day before market closed Pf, bitcoin score
    % Sb, and a guess for gold score Sg_guess.

syms x

% Guess error
% epsilon = 5;

% Given
Nb = Normalised_score(Sb);
Sc = -2*x*Sb/(x+Sb);
Nc = Normalised_score(Sc);
Ng = Normalised_score(x);


eqnLeft = Pf;
eqnRight = Ng/(Ng + Nb + Nc);
% eqnLeft = Ng;
% eqnRight = Pf*(Ng + Nb + Nc);
% eqnLeft = Ng;
% eqnRight = Pf*(Nb + Nc)/(1-Pf);


% fplot([eqnLeft eqnRight], [-200 200])
% title([texlabel(eqnLeft) ' = ' texlabel(eqnRight)])

% Sg = goal_seek(@prop_calc,Sg_guess, Sb, Pf);
Sg = vpasolve(eqnLeft == eqnRight, x, [Sg_guess - epsilon, Sg_guess + epsilon]);

% In case goal_seek doesn't work
if isempty(Sg)
    Sg = solve(eqnLeft == eqnRight, x);
    if isempty(Sg)
        Sg = vpasolve(eqnLeft == eqnRight, x, Sg_guess);
        if isempty(Sg)
            Sg = vpasolve(eqnLeft == eqnRight, x, [Sg_guess- epsilon, Sg_guess + epsilon], 'Random',true);
            if isempty(Sg)
                Sg = vpasolve(eqnLeft == eqnRight, x, 'Random',true);
                if isempty(Sg)
                    Sg = vpasolve(eqnLeft == eqnRight, x, [Sg_guess - 10*epsilon, Sg_guess + 10*epsilon]);
                    if isempty(Sg)
                        Sg = goal_seek(@prop_calc,Sg_guess, Sb, Pf);
                    end
                end
            end
        end
    end
end










end

