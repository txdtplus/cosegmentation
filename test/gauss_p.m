function p = gauss_p(x,mu,cov)

n = length(x);
p = 1/((2*pi)^(n/2)*(det(cov))*0.5)*...
    exp(-1/2*(x - mu)'*cov^(-1)*(x - mu));

end

