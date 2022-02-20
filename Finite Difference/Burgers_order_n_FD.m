function u_next = Burgers_order_n_FD(u_prev, dx, dt, order)
%BURGERS_ORDER_N_FD u^{n+1}_j = u^n_j - a \frac{\delta t}{\delta x} (coef_0*u^n_{j} + coef_1*u^n_{j+1} + ... + coef_{n}*u^n_{j+n})


len_x = length(u_prev);
u_next = zeros(1,len_x);


for i = 2:len_x-1
    % Conditional Order
    if i <= order && u_prev(i) > 0
        cond_order = i - 1;
    elseif len_x - i <= order && u_prev(i) <= 0
        cond_order = len_x - i - 1;
    else
        cond_order = order;
    end
    
    % Direction
    if u_prev(i) > 0
        % backward
        op = @minus;
        coef = flip(FD_Coef(-cond_order:0,1));
    else
        % forward
        op = @plus;
        coef = FD_Coef(0:cond_order,1);
    end
    
    % Finite Difference
    FD = 0;
    for j = 0:cond_order
        FD = FD + coef(j+1) * u_prev(op(i,j));
    end

    % Solution
    u_next(i) = u_prev(i) - u_prev(i) * dt / dx * FD;
end

% boundary conditions
u_next(1) = u_prev(1);
u_next(end) = u_prev(end);


end