clear; clc; close all

load Ic; load img; load par
lambda = 0.25;
sqrt_2 = sqrt(2);
T = 196.3987;
[M,N,H] = size(img1);

%% build n-link graph, connecting pixel p and pixel q
% [nlink_graph,dist] = build_img_graph(M,N);

%% calculate Vpq between pixel p and pixel q
% V_pq = Vpq(img1,dist,nlink_graph);

%% calulate W using equation (10)
% W = cal_W(V_pq,M,N);
W = 8.1177;