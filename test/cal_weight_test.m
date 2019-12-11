clear; clc; close all

load Ic;
load img;
lambda = 0.25;
T = 196.3987;
[M,N] = size(Ic);
pixnum = M*N;
rol_mat = repmat((1:M)',1,N);
col_mat = repmat(1:N,M,1);

loc_Stack = cat(3,rol_mat,col_mat);       % add rol index and col index
loc_vector = reshape(loc_Stack,[pixnum,2]);

numNodes = M*N;
numEdges = 4*M*N - 3*(M + N) + 2;

% tlink = zeros(M,N);
%
% slink = lambda*Dp(Ic,T,'fg');
% slink(Ic>2*T) = 0;
n_graph = zeros(numEdges,4);
ie = 1;     % edge index

% loc_vector(i,1) is row index
% loc_vector(i,2) is column index

%% traverse all the pixels and build graph model

M = 10;
N = 15;
pixnum = M*N;
rol_mat = repmat((1:M)',1,N);
col_mat = repmat(1:N,M,1);
numEdges = 4*M*N - 3*(M + N) + 2;
n_graph = zeros(numEdges,4);

loc_Stack = cat(3,rol_mat,col_mat);       % add rol index and col index
loc_vector = reshape(loc_Stack,[pixnum,2]);

for i = 1:pixnum
    
    if mod(i,1e4) == 0
        disp(['build edges for ',num2str(i),'th pixel']);
    end
    
    if loc_vector(i,1) == M && loc_vector(i,2) == N
        %% bottom right corner
        continue;
    end
    
    if loc_vector(i,1) == M && loc_vector(i,2) ~= N
        %% Pixels on Image bottom, not bottom right corner
        n_graph(ie,1:2) = loc_vector(i,:);
        n_graph(ie,3) = loc_vector(i,1);
        n_graph(ie,4) = loc_vector(i,2) + 1;
        % Connect the edges to the right pixel
        ie = ie + 1;
        continue;
    end
    
    if loc_vector(i,1) ~= M && loc_vector(i,2) == 1
        %% Pixels on Image left, not bottom
        n_graph(ie,1:2) = loc_vector(i,:);
        n_graph(ie,3) = loc_vector(i,1);
        n_graph(ie,4) = loc_vector(i,2) + 1;
        % Connect the edges to the right pixel
        ie = ie + 1;
        
        n_graph(ie,1:2) = loc_vector(i,:);
        n_graph(ie,3) = loc_vector(i,1) + 1;
        n_graph(ie,4) = loc_vector(i,2);
        % Connect the edges to the lower pixel
        ie = ie + 1;
        
        n_graph(ie,1:2) = loc_vector(i,:);
        n_graph(ie,3) = loc_vector(i,1) + 1;
        n_graph(ie,4) = loc_vector(i,2) + 1;
        % Connect the edges to the right lower pixel
        ie = ie + 1;
        continue;
    end
    
    if loc_vector(i,1) ~= M && loc_vector(i,2) == N
        %% Pixels on Image right, not bottom
        n_graph(ie,1:2) = loc_vector(i,:);
        n_graph(ie,3) = loc_vector(i,1) + 1;
        n_graph(ie,4) = loc_vector(i,2);
        % Connect the edges to the lower pixel
        ie = ie + 1;
        
        n_graph(ie,1:2) = loc_vector(i,:);
        n_graph(ie,3) = loc_vector(i,1) + 1;
        n_graph(ie,4) = loc_vector(i,2) - 1;
        % Connect the edges to the left lower pixel
        ie = ie + 1;
        continue;
    end
    
    %% else
    n_graph(ie,1:2) = loc_vector(i,:);
    n_graph(ie,3) = loc_vector(i,1);
    n_graph(ie,4) = loc_vector(i,2) + 1;
    % Connect the edges to the right pixel
    ie = ie + 1;
    
    n_graph(ie,1:2) = loc_vector(i,:);
    n_graph(ie,3) = loc_vector(i,1) + 1;
    n_graph(ie,4) = loc_vector(i,2);
    % Connect the edges to the lower pixel
    ie = ie + 1;
    
    n_graph(ie,1:2) = loc_vector(i,:);
    n_graph(ie,3) = loc_vector(i,1) + 1;
    n_graph(ie,4) = loc_vector(i,2) + 1;
    % Connect the edges to the right lower pixel
    ie = ie + 1;
    
    n_graph(ie,1:2) = loc_vector(i,:);
    n_graph(ie,3) = loc_vector(i,1) + 1;
    n_graph(ie,4) = loc_vector(i,2) - 1;
    % Connect the edges to the left lower pixel
    ie = ie + 1;
end

figure;
hold on
for i = 1:numEdges
    plot([n_graph(i,2),n_graph(i,4)],[n_graph(i,1),n_graph(i,3)],...
        '-o','LineWidth',1,'MarkerSize',10,'MarkerFaceColor','r');   
end
hold off;