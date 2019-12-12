clear; clc; close all;
addpath('src');
addpath('src\EM');
addpath('src\GC');
addpath('src\build_graph');

%% preprocessing
[img1,map1] = imread('..\cosegmentation_data\C2009.tif','tif');
[img2,map2] = imread('..\cosegmentation_data\C2012M.tif','tif');
img1 = double(round(img1));
img2 = double(round(img2));
[M,N,H] = size(img1);

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
load ..\cosegmentation_data\MBI;
img1 = cat(3,img1,MBI1);
img2 = cat(3,img2,MBI2);
Ic = img_diff(img1,img2);

%% calulate threshold using Bayes theory
% [T_theory,T_experiment] = cal_threshold(Ic);
T_theory = 191.6429;
T_experiment = 196.3987;
T = T_experiment;

%% build graph and calculate edge weights
% lambda1 = 0.25;
% lambda2 = 0.1;
% [termWeights_1, edgeWeights_1] = cal_wight(img1,Ic,lambda1,T);
% [termWeights_2, edgeWeights_2] = cal_wight(img2,Ic,lambda2,T);
load ..\cosegmentation_data\graph_par;

%% graph-cut algorithm for cosegmentation
tic
[cut_1, labels_1] = graphCutMex(termWeights_1, edgeWeights_1);
[cut_2, labels_2] = graphCutMex(termWeights_2, edgeWeights_2);
toc

seg1 = reshape(labels_1, [M N]);
seg2= reshape(labels_2, [M N]);
se1=strel('square',5);
se2=strel('square',3);
figure(8);
seg1=imclose(seg1,se2);
seg1=imopen(seg1,se1);
seg1 = imfill(seg1,'holes');
imshow(seg1);
title('T1');