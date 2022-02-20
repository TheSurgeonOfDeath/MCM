function [coef, s_mat,  deriv_mat]= FD_Coef(stencil_pts, derivative_order)
%FD_COEF Finite Difference coefficients given stencil points and order of
%derivative



len_s = length(stencil_pts);

% d < N
if derivative_order >= len_s
    coef = 0;
    return;
end


% stencil points in ascending order
stencil_pts = sort(stencil_pts);

% Stencil Matrix
s_mat = zeros(len_s);
for i = 0:len_s-1
    s_mat(i+1,:) = stencil_pts.^i;
end

% Derivative order Matrix (d! * Kronecker_delta)
deriv_mat = zeros(len_s, 1);
deriv_mat(derivative_order+1) = factorial(derivative_order);

% FD Coefficients
coef = s_mat\deriv_mat;

end

