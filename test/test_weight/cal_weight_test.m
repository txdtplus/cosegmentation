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

%% calculate edgeWeights for following graph cut algorithm
edgeNum = length(V_pq);
edgeWeights = zeros(edgeNum,4);
edgeWeights(:,1) = (nlink_graph(:,2)-1)*M + nlink_graph(:,1);
edgeWeights(:,2) = (nlink_graph(:,4)-1)*M + nlink_graph(:,3);
edgeWeights(:,3) = (1 - lambda)*V_pq;    
edgeWeights(:,4) = (1 - lambda)*V_pq;

%% calulate W using equation (10)
% W = cal_W(V_pq,M,N);
W = 8.1177;

%% calculate termWeights for following graph cut algorithm
pixelNum = M*N;
termWeights = zeros(pixelNum,2);

termWeights_sp_mat = lambda*Dp(Ic,T,'fg');
termWeights_sp_mat(Ic>2*T) = 0;
termWeights_tp_mat = lambda*Dp(Ic,T,'bg');
termWeights_tp_mat(Ic>2*T) = W;

termWeights(:,1) = reshape(termWeights_sp_mat,[pixelNum,1]);
termWeights(:,2) = reshape(termWeights_tp_mat,[pixelNum,1]);