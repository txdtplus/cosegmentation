function y = stepfun(x,a,b)
y = x;
y(y<a) = a;
y(y>b) = b;
end

