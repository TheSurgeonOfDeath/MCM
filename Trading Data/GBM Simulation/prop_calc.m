function Pg = prop_calc(Sg, Sb)
%PROP_CALC Calculates gold proportion Pg given scores Sg and Sb.

Sc =  -2 .* Sg .* Sb ./ (Sg + Sb);

Ng = Normalised_score(Sg);
Nb = Normalised_score(Sb);
Nc = Normalised_score(Sc);

scoreSum = Ng + Nb + Nc;
Pg = Ng ./ scoreSum;



end

