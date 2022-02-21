function x = goal_seek(myfun,x_guess, param, target)
%GOAL_SEEK similar to goal seek in excel
f = @(x) myfun(x, param)-target;
x = fsolve(f,x_guess);


end

