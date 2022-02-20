syms x
% eqnLeft = 200*sin(x);
% eqnRight = x^3 - 1;

% Given
Pc = 1;
Pf = 0.4175019123;
Sb = 2.4;
Nb = 1/(1+exp(-Sb));
Sc = -2*x*Sb/(x+Sb);
Nc = 1/(1+exp(-Sc));
Ng = 1/(1+exp(-x));


eqnLeft = Pf;
eqnRight = Ng/(Ng + Nb + Nc);

fplot([eqnLeft eqnRight])
title([texlabel(eqnLeft) ' = ' texlabel(eqnRight)])

S1 = vpasolve(eqnLeft == eqnRight, x, Pc);
% S2 = vpasolve(eqnLeft == eqnRight, x, -3);
% S3 = vpasolve(eqnLeft == eqnRight, x, 4);
