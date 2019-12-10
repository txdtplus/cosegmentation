clear; clc; close all;
load h_Ic;
load Ic
h = h_Ic;
l = length(h);
MD = round(l/2);
alpha = 0.3;
Tn = MD*(1-alpha);
Tc = MD*(1+alpha);

[M,N] =size(Ic);
x = reshape(Ic,[1,M*N]);
Sn = x(x<Tn);
Sc = x(x>Tc);

k = 2;
mu_c = cell(1,k);
var_c = cell(1,k);
mu_c{1} = mean(Sn);
mu_c{2} = mean(Sc);
var_c{1} = var(Sn);
var_c{2} = var(Sc);

a = 1/k*ones(k,1);

m = M*N;
gamma = zeros(m,k);
iter_num = 20;

for it = 1:iter_num
    parfor j = 1:m
        p = px(a,x(j),mu_c,var_c);
        for i = 1:k
            gamma(j,i) = a(i)*gauss_p(x(j),mu_c{i},var_c{i})/p;
        end
        if mod(j,10000) == 0
            disp(['',num2str(j),'th calculation finished!']);
        end
    end
    
    for i = 1:k
        sum_gamma = sum(gamma(:,i));
        mu_c{i} = x*gamma(:,i)/sum_gamma;
        
        x_squ = (x - mu_c{i}).*(x - mu_c{i});
        var_c{i} = x_squ*gamma(:,i)/sum_gamma;
        a(i) = sum_gamma/m;
    end
end

[~,index] = max(gamma,[],2);
index = index - 1;
change_img = reshape(index,[M,N]);
imshow(change_img);
pwc = sum(index)/m;
pwn = 1 - pwc;
save par pwc pwn mu_c var_c x index
