clear;
clc;
close all;

a = 1;
b = 1;
c = 1;

a1 = zeros(1,1e7);
tic
parfor i = 1:1e7
    a1(i) = 2*3+5;
end
toc