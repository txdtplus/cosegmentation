function px = px(a,x,mu_cell,cov_cell)

k = length(a);
p = zeros(k,1);
for i = 1:k
    p(i) = gauss_p(x,mu_cell{i},cov_cell{i});
end
px = a'*p;
end

