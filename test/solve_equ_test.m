clear; clc; close all;

load par;
sigma_n_2 = var_cell{1};
sigma_n = sqrt(sigma_n_2);
sigma_c_2 = var_cell{2};
sigma_c = sqrt(sigma_c_2);
mu_n = mu_cell{1};
mu_cell = mu_cell{2};

a = sigma_n_2 - sigma_c_2;
b = 2*(mu_n*sigma_c_2 - mu_cell*sigma_n_2);
c = mu_cell^2*sigma_n_2 - mu_n^2*sigma_c_2 - ...
    2*sigma_n_2*sigma_c_2*log(sigma_n*pwc/(sigma_c*pwn));

T0 = (-b-sqrt(b^2 - 4*a*c))/(2*a);
index = index';
yc = x.*index;
yn = x.*(1 - index);
yc(yc == 0) = [];
yn(yn == 0) = [];
min(yc)
max(yn)

[idx,c] = kmeans(x',2);

idx = idx - 1;
M = 901; N = 1601;
change_img1 = reshape(index,[M,N]);
change_img2 = reshape(idx,[M,N]);
figure;
imshow(change_img2)
title('kmeans');
figure;
imshow(change_img1)
title('Gaussian mixture');
