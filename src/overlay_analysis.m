function [seg1_oa,seg2_oa] = overlay_analysis(seg1,seg2)


[M,N] = size(seg1);
[L1,~]= bwlabel(seg1,8);
[L2,~]= bwlabel(seg2,8);
states_1 = regionprops(L1,'Area','PixelList');
states_2 = regionprops(L2,'Area','PixelList');

seg1_oa = seg1;
seg2_oa = seg2;
zero_MN = zeros(M,N);

%% overlay analysis
mask = zero_MN;

% segmentation 1 overlay analysis
for i = 1:size(states_1,1)
    idx = sub2ind(size(mask), states_1(i).PixelList(:,2), states_1(i).PixelList(:,1));
    mask(idx) = 1;
    % extract all objects' mask respectively
    
    mask = mask.*seg2;
    % intersect operation between a single object and sthe other map
    if max(max(mask)) == 0
        idx = sub2ind(size(mask), states_1(i).PixelList(:,2), states_1(i).PixelList(:,1));
        seg1_oa(idx) = 0;
        % delete object that have no overlaid objects in the other map
    end
    mask = zero_MN;
end

% segmentation 2 overlay analysis
for i = 1:size(states_2,1)
    idx = sub2ind(size(mask), states_2(i).PixelList(:,2), states_2(i).PixelList(:,1));
    mask(idx) = 1;
    % extract all objects' mask respectively
    
    mask = mask.*seg1;
    % intersect operation between a single object and the other map
    if max(max(mask)) == 0
        idx = sub2ind(size(mask), states_2(i).PixelList(:,2), states_2(i).PixelList(:,1));
        seg2_oa(idx) = 0;  
        % delete object that have no overlaid objects in the other map
    end
    mask = zero_MN;
end

end

