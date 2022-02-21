function x = goal_seek(myfun,x_guess, param, target)
%GOAL_SEEK similar to goal seek in excel
f = @(x) myfun(x, param)-target;
options = optimset('Display','off');
x = fsolve(f,x_guess, options);


end

