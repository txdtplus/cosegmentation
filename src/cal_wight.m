function [terminalWeights,edgeWeights]=cal_wight(img,Ic,lambda,T)
% calculate edge weights in the graph
% termWeights	-	the edges connecting the source and the sink with the regular nodes 
%               (array of type double, size : [numNodes, 2])
% edgeWeights	-	the edges connecting regular nodes with each other 
%               (array of type double, array size [numEdges, 4])
% img is original image adding MBI.
%
% Ic is the norm of difference image.
%
% lambda is a parameter   E = lambda*E_change + (1 - lambda)*E_image
%
% T is threshold calculated by EM algorithm

[M,N] = size(Ic);
numNodes = M*N;
numEdges = 4*M*N - 3*(M + N) + 2;
end

