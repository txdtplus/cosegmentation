function W = cal_W(V_pq,M,N)
% calculate W
% V_pq is edge weight. It is a numEdges*1 vector
% M and N are row number and column number repectively.
% W is a scaler
%
% This function use struct to represent a pixel. The elements in one
% struct consist of 8-neighborhood edges. The value of element is edge
% weight.

fprintf('calculating W ...\n\n');
img_cell = cell(M,N);
ie = 1;
fprintf('initalizing pixel struct ...\n\n');
for i = 1:M
    if mod(i,10) == 0
        disp(['initalizing pixel struct on the ',num2str(i),'th row']);
    end
    for j = 1:N
        img_cell{i,j}.up = 0;        img_cell{i,j}.down = 0;
        img_cell{i,j}.left = 0;      img_cell{i,j}.right = 0;
        img_cell{i,j}.up_right = 0;  img_cell{i,j}.down_right = 0;
        img_cell{i,j}.up_left = 0;   img_cell{i,j}.down_left = 0;
    end
end

fprintf('\n\nbuilding struct graph model ...\n\n');
for i = 1:M
    if mod(i,5) == 0
        disp(['building pixel graph model on the ',num2str(i),'th row']);
    end
    for j = 1:N
               
        if i == M && j == N
            %% bottom right corner
            continue;
        end
        
        if i == M && j ~= N
            %% Pixels on Image bottom, not bottom right corner
            img_cell{i,j}.right = V_pq(ie);
            img_cell{i,j+1}.left = V_pq(ie);
            % Connect the edges to the right pixel
            ie = ie + 1;
            continue;
        end
        
        if i ~= M && j == 1
            %% Pixels on Image left, not bottom
            img_cell{i,j}.right = V_pq(ie);
            img_cell{i,j+1}.left = V_pq(ie);
            % Connect the edges to the right pixel
            ie = ie + 1;
            
            img_cell{i,j}.down = V_pq(ie);
            img_cell{i+1,j}.up = V_pq(ie);
            % Connect the edges to the lower pixel
            ie = ie + 1;
            
            img_cell{i,j}.down_right = V_pq(ie);
            img_cell{i+1,j+1}.up_left = V_pq(ie);
            % Connect the edges to the right lower pixel
            ie = ie + 1;
            continue;
        end
        
        if i ~= M && j == N
            %% Pixels on Image right, not bottom
            img_cell{i,j}.down = V_pq(ie);
            img_cell{i+1,j}.up = V_pq(ie);
            % Connect the edges to the lower pixel
            ie = ie + 1;
            
            img_cell{i,j}.down_left = V_pq(ie);
            img_cell{i+1,j-1}.up_right = V_pq(ie);
            % Connect the edges to the left lower pixel
            ie = ie + 1;
            continue;
        end
        
        %% else
        img_cell{i,j}.right = V_pq(ie);
        img_cell{i,j+1}.left = V_pq(ie);
        % Connect the edges to the right pixel
        ie = ie + 1;
        
        img_cell{i,j}.down = V_pq(ie);
        img_cell{i+1,j}.up = V_pq(ie);
        % Connect the edges to the lower pixel
        ie = ie + 1;
        
        img_cell{i,j}.down_right = V_pq(ie);
        img_cell{i+1,j+1}.up_left = V_pq(ie);
        % Connect the edges to the right lower pixel
        ie = ie + 1;
        
        img_cell{i,j}.down_left = V_pq(ie);
        img_cell{i+1,j-1}.up_right = V_pq(ie);
        % Connect the edges to the left lower pixel
        ie = ie + 1;
        
    end
end

fprintf('\n\ncalculating sum V of every pixel ...\n\n');
nodeSumV = zeros(M,N);
for i = 1:M
    for j = 1:N
        img_cell{i,j}.sumV = img_cell{i,j}.up + img_cell{i,j}.down +...
            img_cell{i,j}.left + img_cell{i,j}.right +...
            img_cell{i,j}.up_right + img_cell{i,j}.down_right +...
            img_cell{i,j}.up_left + img_cell{i,j}.down_left;
        nodeSumV(i,j) = img_cell{i,j}.sumV;
    end
end

W = 1 + max(max(nodeSumV));

end

