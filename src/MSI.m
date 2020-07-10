classdef MSI < handle
    %MSI is a Multispectral Image object.
    %
    %   MSI - Initialization Function
    %
    %   tensor2mat - Flatten the 3D data to 2D data.
    %
    
    properties
        data
        shape
    end
    
    methods
        function obj = MSI(data)
            % The array him should be a 3D array: [m, n, l].
            % l should be the number of the bands.
            obj.data = data;
            obj.shape = size(data);
        end
        
        function X = tensor2mat(obj)
            h = obj.shape(end);
            X = (reshape(obj.data,[],h))';
        end
        
        function idx = gen_idx(obj)
            % idx is an M*N matrix, which indicates the 1D index of pixel
            M = obj.shape(1);
            N = obj.shape(2);
            idx = reshape(1:M*N,M,N);
        end
    end
end

