function px = px(a,x,mu,cov)

k = length(a);
p = zeros(k,1);
for i = 1:k
    p(i) = gauss_p(x,mu(:,i),cov(:,:,i));
end
px = a'*p;
end

