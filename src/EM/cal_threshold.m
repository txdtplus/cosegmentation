function [T_theory,T_experiment]= cal_threshold(Ic)
% calculate threshold using EM algorthms
% Ic is difference image
[M,N] =size(Ic);

%% calculate iterative initial value using histogram
h = imhist16(floor(Ic));
l = length(h);
MD = round(l/2);
alpha = 0.3;
Tn = MD*(1-alpha);
Tc = MD*(1+alpha);
x = reshape(Ic,[1,M*N]);        % generate 1D data
m = length(x);

%% estimate mean and variance of 2 classes using EM 
[mu,sigma2,gamma] = cal_EM(x,Tn,Tc);

%% determine prior probability of changed and unchanged area
[~,index] = max(gamma,[],2);
index = index - 1;
pwc = sum(index)/m;
pwn = 1 - pwc;

%% solve the threshold theoretically
sigma_n_2 = sigma2(:,:,1);
sigma_n = sqrt(sigma_n_2);
sigma_c_2 = sigma2(:,:,2);
sigma_c = sqrt(sigma_c_2);
mu_n = mu(:,1);
mu_c = mu(:,2);

a = sigma_n_2 - sigma_c_2;
b = 2*(mu_n*sigma_c_2 - mu_c*sigma_n_2);
c = mu_c^2*sigma_n_2 - mu_n^2*sigma_c_2 - ...
    2*sigma_n_2*sigma_c_2*log(sigma_n*pwc/(sigma_c*pwn));

T_theory = (-b-sqrt(b^2 - 4*a*c))/(2*a);

%% solve the threshold experimentally
index = index';
yc = x.*index;
yn = x.*(1 - index);
yc(yc == 0) = [];
yn(yn == 0) = [];
T1 = min(yc);
T2 = max(yn);
T_experiment = (T1 + T2)/2;
end


%% EM algorithm
function [mu,sigma2,gamma] = cal_EM(x,Tn,Tc)
% EM algorithm
% x should be d*m, d is dimension and m is number of sample capacity
% Tn and Tc are 2 thresholds.

Sn = x(x<Tn);
Sc = x(x>Tc);
[d,m] = size(x);
k = 2;

mu = zeros(d,k);
sigma2 = zeros(d,d,k);
mu(:,1) = mean(Sn,2);
mu(:,2) = mean(Sc,2);
sigma2(:,:,1) = var(Sn);
sigma2(:,:,2) = var(Sc);

a = 1/k*ones(k,1);

gamma = zeros(m,k);
iter_num = 20;

for it = 1:iter_num
    parfor j = 1:m
        p = px(a,x(j),mu,sigma2);
        for i = 1:k
            gamma(j,i) = a(i)*gauss_p(x(j),mu(:,i),sigma2(:,:,i))/p;
        end
        if mod(j,10000) == 0
            disp(['EM algorithm: ',num2str(j),'th calculation finished!']);
        end
    end
    
    for i = 1:k
        sum_gamma = sum(gamma(:,i));
        mu(:,i) = x*gamma(:,i)/sum_gamma;
        
        x_squ = (x - mu(:,i)).*(x - mu(:,i));
        sigma2(:,:,i) = x_squ*gamma(:,i)/sum_gamma;
        a(i) = sum_gamma/m;
    end
end

end
