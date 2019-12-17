function [seg1_show,seg2_show] = assign_label(seg1_oa,seg2_oa)
% assign labels for the same object
union_segoa = seg1_oa | seg2_oa;
[M,N] = size(union_segoa);

[L,num] = bwlabel(union_segoa);
color = randi(255,[1,num+1,3]);
color(1,1,:) = 0;

seg1_label = L .* seg1_oa + 1;
seg2_label = L .* seg2_oa + 1;

seg1_show = zeros(M,N,3);
seg2_show = zeros(M,N,3);
for i = 1:M
    for j = 1:N
        seg1_show(i,j,:) = color(1,seg1_label(i,j),:);
        seg2_show(i,j,:) = color(1,seg2_label(i,j),:);
    end   
end

seg1_show = uint8(seg1_show);
seg2_show = uint8(seg2_show);
end

