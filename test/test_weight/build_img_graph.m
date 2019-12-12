function [nlink_graph,dist] = build_img_graph(M,N)
% build n-link graph, connecting pixel p and pixel q
% nlink_graph is a numEdges*4 matrix
%        nlink_graph(:,1) is row index of p
%        nlink_graph(:,2) is column index of p
%        nlink_graph(:,3) is row index of q
%        nlink_graph(:,4) is column index of q
%
% dist is Euclidian distance between of p and q
%
% M and N are respectively row and column numbers of image

pixnum = M*N;   sqrt_2 = sqrt(2);
rol_mat = repmat((1:M)',1,N);
col_mat = repmat(1:N,M,1);
loc_Stack = cat(3,rol_mat,col_mat);       % rol index and col index
loc_vector = reshape(loc_Stack,[pixnum,2]);
% loc_vector(i,1) is row index
% loc_vector(i,2) is column index
numEdges = 4*M*N - 3*(M + N) + 2;
nlink_graph = zeros(numEdges,4);
dist = zeros(numEdges,1);
ie = 1;     % edge index

%% traverse all the pixels and build graph model
fprintf('building graph model ...\n\n');
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
        nlink_graph(ie,1:2) = loc_vector(i,:);
        nlink_graph(ie,3) = loc_vector(i,1);
        nlink_graph(ie,4) = loc_vector(i,2) + 1;
        % Connect the edges to the right pixel
        dist(ie) = 1;
        ie = ie + 1;
        continue;
    end
    
    if loc_vector(i,1) ~= M && loc_vector(i,2) == 1
        %% Pixels on Image left, not bottom
        nlink_graph(ie,1:2) = loc_vector(i,:);
        nlink_graph(ie,3) = loc_vector(i,1);
        nlink_graph(ie,4) = loc_vector(i,2) + 1;
        % Connect the edges to the right pixel
        dist(ie) = 1;
        ie = ie + 1;
        
        nlink_graph(ie,1:2) = loc_vector(i,:);
        nlink_graph(ie,3) = loc_vector(i,1) + 1;
        nlink_graph(ie,4) = loc_vector(i,2);
        dist(ie) = 1;
        % Connect the edges to the lower pixel
        ie = ie + 1;
        
        nlink_graph(ie,1:2) = loc_vector(i,:);
        nlink_graph(ie,3) = loc_vector(i,1) + 1;
        nlink_graph(ie,4) = loc_vector(i,2) + 1;
        dist(ie) = sqrt_2;
        % Connect the edges to the right lower pixel
        ie = ie + 1;
        continue;
    end
    
    if loc_vector(i,1) ~= M && loc_vector(i,2) == N
        %% Pixels on Image right, not bottom
        nlink_graph(ie,1:2) = loc_vector(i,:);
        nlink_graph(ie,3) = loc_vector(i,1) + 1;
        nlink_graph(ie,4) = loc_vector(i,2);
        % Connect the edges to the lower pixel
        dist(ie) = 1;
        ie = ie + 1;
        
        nlink_graph(ie,1:2) = loc_vector(i,:);
        nlink_graph(ie,3) = loc_vector(i,1) + 1;
        nlink_graph(ie,4) = loc_vector(i,2) - 1;
        dist(ie) = sqrt_2;
        % Connect the edges to the left lower pixel
        ie = ie + 1;
        continue;
    end
    
    %% else
    nlink_graph(ie,1:2) = loc_vector(i,:);
    nlink_graph(ie,3) = loc_vector(i,1);
    nlink_graph(ie,4) = loc_vector(i,2) + 1;
    dist(ie) = 1;
    % Connect the edges to the right pixel
    ie = ie + 1;
    
    nlink_graph(ie,1:2) = loc_vector(i,:);
    nlink_graph(ie,3) = loc_vector(i,1) + 1;
    nlink_graph(ie,4) = loc_vector(i,2);
    dist(ie) = 1;
    % Connect the edges to the lower pixel
    ie = ie + 1;
    
    nlink_graph(ie,1:2) = loc_vector(i,:);
    nlink_graph(ie,3) = loc_vector(i,1) + 1;
    nlink_graph(ie,4) = loc_vector(i,2) + 1;
    % Connect the edges to the right lower pixel
    dist(ie) = sqrt_2;
    ie = ie + 1;
    
    nlink_graph(ie,1:2) = loc_vector(i,:);
    nlink_graph(ie,3) = loc_vector(i,1) + 1;
    nlink_graph(ie,4) = loc_vector(i,2) - 1;
    % Connect the edges to the left lower pixel
    dist(ie) = sqrt_2;
    ie = ie + 1;
end

end

