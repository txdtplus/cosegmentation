function [termWeights, edgeWeights] = cal_weight(img,Ic,lambda,T)
% calculate edge weights for graph cut
% termWeights	-	the edges connecting the source and the sink with the regular nodes (array of type double, size : [numNodes, 2])
% 				termWeights(i, 1) is the weight of the edge connecting the source with node #i
% 				termWeights(i, 2) is the weight of the edge connecting node #i with the sink
% 				numNodes is determined from the size of termWeights.
% edgeWeights	-	the edges connecting regular nodes with each other (array of type double, array size [numEdges, 4])
% 				edgeWeights(i, 3) connects node #edgeWeights(i, 1) to node #edgeWeights(i, 2)
% 				edgeWeights(i, 4) connects node #edgeWeights(i, 2) to node #edgeWeights(i, 1)
%				The only requirement on edge weights is submodularity: edgeWeights(i, 3) + edgeWeights(i, 4) >= 0

%% initalize
I_obj = MSI(img);
idx = I_obj.gen_idx();
sqrt_2 = sqrt(2);
M = I_obj.shape(1);
N = I_obj.shape(2);

%% calculate submatrix index
% get index of 8 directions
% 0 degree, 45 degree, 90 degree, 135 degree
idx0_2 = idx(:,2:end);      % index of node 2
idx0_1 = idx(:,1:end-1);    % index of node 1
idx45_2 = idx(1:end-1,2:end);
idx45_1 = idx(2:end,1:end-1);
idx90_2 = idx(1:end-1,:);
idx90_1 = idx(2:end,:);
idx135_2 = idx(1:end-1,1:end-1);
idx135_1 = idx(2:end,2:end);

% reshape to 1D column vector
idx0_1 = reshape(idx0_1,[],1);
idx45_1 = reshape(idx45_1,[],1);
idx90_1 = reshape(idx90_1,[],1);
idx135_1 = reshape(idx135_1,[],1);
idx0_2 = reshape(idx0_2,[],1);
idx45_2 = reshape(idx45_2,[],1);
idx90_2 = reshape(idx90_2,[],1);
idx135_2 = reshape(idx135_2,[],1);

%% diff in 4 directions (the other 4 derections are opposite directions)
% point to 0бу  node 1 ----> node 2
diff_0 = MSI(img(:,2:end,:) - img(:,1:end-1,:));
d_0 = ones(diff_0.shape(1),diff_0.shape(2));

% point to 45бу
diff_45 = MSI(img(1:end-1,2:end,:) - img(2:end,1:end-1,:));
d_45 = sqrt_2 * ones(diff_45.shape(1),diff_45.shape(2));

% point to 90бу
diff_90 = MSI(img(1:end-1,:,:) - img(2:end,:,:));
d_90 = ones(diff_90.shape(1),diff_90.shape(2));

% point to 135бу
diff_135 = MSI(img(1:end-1,1:end-1,:) - img(2:end,2:end,:));
d_135 = sqrt_2 * ones(diff_135.shape(1),diff_135.shape(2));

clear img

%% calculate Vpq
IpIq_0 = sum(diff_0.data.^2,3);
IpIq_45 = sum(diff_45.data.^2,3);
IpIq_90 = sum(diff_90.data.^2,3);
IpIq_135 = sum(diff_135.data.^2,3);

sigma_2 = mean([mean(IpIq_0,'all'),mean(IpIq_45,'all'),...
    mean(IpIq_90,'all'),mean(IpIq_135,'all')]);

Vpq_0 = exp(-IpIq_0/(2*sigma_2))./d_0;
Vpq_45 = exp(-IpIq_45/(2*sigma_2))./d_45;
Vpq_90 = exp(-IpIq_90/(2*sigma_2))./d_90;
Vpq_135 = exp(-IpIq_135/(2*sigma_2))./d_135;

Vpq = [reshape(Vpq_0,[],1); reshape(Vpq_45,[],1);...
    reshape(Vpq_90,[],1); reshape(Vpq_135,[],1)];

clear diff_0 diff_45 diff_90 diff_135
clear IpIq_0 IpIq_45 IpIq_90 IpIq_135
clear d_0 d_45 d_90 d_135

%% calculate edgeWeights
edgeWeights = zeros(size(Vpq,1),4);

edgeWeights(:,1) = [idx0_1;idx45_1;idx90_1;idx135_1]; % index of node 1
edgeWeights(:,2) = [idx0_2;idx45_2;idx90_2;idx135_2]; % index of node 2
edgeWeights(:,3) = (1 - lambda)*Vpq;                  % node 1 ---> node 2
edgeWeights(:,4) = (1 - lambda)*Vpq;                  % node 2 ---> node 1

clear idx0_1 idx45_1 idx90_1 idx135_1
clear idx0_2 idx45_2 idx90_2 idx135_2

%% calculate W
Vpq_tensor = zeros(M,N,8);

Vpq_tensor(:,2:end,1) = Vpq_0;
Vpq_tensor(:,1:end-1,2) = Vpq_0;
Vpq_tensor(1:end-1,2:end,3) = Vpq_45;
Vpq_tensor(2:end,1:end-1,4) = Vpq_45;
Vpq_tensor(1:end-1,:,5) = Vpq_90;
Vpq_tensor(2:end,:,6) = Vpq_90;
Vpq_tensor(1:end-1,1:end-1,7) = Vpq_135;
Vpq_tensor(2:end,2:end,1) = Vpq_135;

sum_V = sum(Vpq_tensor,3);
W = max(max(sum_V));

clear sum_V Vpq_tensor

%% calculate termWeights for following graph cut algorithm
pixelNum = M*N;
termWeights = zeros(pixelNum,2);

termWeights_sp_mat = lambda*Dp(Ic,T,'fg');
termWeights_sp_mat(Ic>2*T) = 0;
termWeights_tp_mat = lambda*Dp(Ic,T,'bg');
termWeights_tp_mat(Ic>2*T) = W;

termWeights(:,1) = reshape(termWeights_sp_mat,[pixelNum,1]);
termWeights(:,2) = reshape(termWeights_tp_mat,[pixelNum,1]);

end


function y = Dp(Ic,T,lp)
% Ic is difference image
% T is threshold
% lp is 'fg' or 'bg'

if strcmp(lp,'fg')
    y = -log(Ic/(2*T));
elseif strcmp(lp,'bg')
    y = -log(1 - Ic/(2*T));
else
    error('lp must be ''fg'' or ''bg'' !');
end
end