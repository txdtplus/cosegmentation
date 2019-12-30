function [mu,sigma,gamma] = cal_EM(x,ini_mu,ini_sigma)
% EM algorithm
% x should be d*m, d is dimension and m is number of sample capacity
% Tn and Tc are 2 thresholds.

iter_num = 50;

mu = ini_mu; sigma = ini_sigma;
k = size(mu,2);
m = size(x,2);
a = 1/k*ones(k,1);

for it = 1:iter_num
    gamma = cal_post_p(a,x,mu,sigma);
    % gamma is k*m
    sum_gamma = sum((gamma'));
    % sum_gamma is 1*k
    
    mu_new = x*gamma'./sum_gamma;
    sigma = update_cov(x,mu,gamma,sum_gamma);
    a = sum_gamma'/m;
    
    if norm(mean(mu_new - mu)) < 1e-5
        break;
    end
    mu = mu_new;
end

end

%% son function

function sigma_new = update_cov(x,mu,gamma,sum_gamma)

k = size(gamma,1);
d = size(x,1);
sigma_new = zeros(d,d,k);
for i = 1:k
    v = x - mu(:,i);
    sigma_new(:,:,i) = gamma(i,:).*v*v'/sum_gamma(i);
end
end


function post_p = cal_post_p(a,x,mu,sigma)
% post_p is k*m

prior_p = cal_prior_p(x,mu,sigma);
mix_p = a'*prior_p;
% mix_p is an 1*m vector
post_p = a.*prior_p./mix_p;

end


