function prior_p = cal_prior_p(x,mu,cov)

[d,k]   = size(mu);
[~,m]   = size(x);
prior_p = zeros(k,m);
detcov  = zeros(1,k);
invcov  = zeros(d,d,k);
coff    = zeros(1,k);

for i = 1:k
    detcov(i) = det(cov(:,:,i));
    invcov(:,:,i) = pinv(cov(:,:,i));
    coff(i) = 1/((2*pi)^(d/2)*sqrt(detcov(i)));
end

% for i = 1:k
%     parfor j = 1:m
%         v = x(:,j) - mu(:,i);
%         prior_p(i,j) = coff(i) * exp(-1/2*v'*invcov(:,:,i)*v);
%     end
% end

for i = 1:k
    v = x - mu(:,i);
    term = sum(v'*invcov(:,:,i).*v',2);
    prior_p(i,:) = coff(i) * exp(-1/2*term');
end


end
