clear; clc; close all;
addpath('src');
%% preprocessing
[img1,map1] = imread('data/C2009.tif','tif');
[img2,map2] = imread('data/C2012M.tif','tif');
img1 = double(round(img1));
img2 = double(round(img2));

%% radiation correction
img1 = rad_corr(img1);
img2 = rad_corr(img2);

% figure;
% imshow(uint8(img1(:,:,4:-1:2)));
% figure;
% imshow(uint8(img2(:,:,4:-1:2)));

%% add MBI and calculate difference image 
% MBI1 = cal_MBI(img1);
% MBI2 = cal_MBI(img2);
load MBI;
img1 = cat(3,img1,MBI1);
img2 = cat(3,img2,MBI2);
Ic = img_diff(img1,img2);

%% calulate threshold using Bayes theory
% [T_theory,T_experiment] = cal_threshold(Ic);
T_theory = 191.6429;
T_experiment = 196.3987;