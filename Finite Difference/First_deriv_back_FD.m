function deriv = First_deriv_back_FD(back_data, dt)
%FIRST_DERIV_BACK_FD First Derivative using a backward finite difference
%method of order length(back_data)-1.

% stencil_pts = -1 * (0:length(back_data)-1);
stencil_pts = -length(back_data)+1:0;

coef = FD_Coef(stencil_pts, 1);

% first Dervivative
deriv = 0;
for i = 1:length(back_data)
    deriv = deriv + coef(i) * back_data(i);
end
deriv = deriv / dt;

end

