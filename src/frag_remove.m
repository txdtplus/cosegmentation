function bw_out = frag_remove(bw,reso)
% fragmentation removal

%% fragmentation remove
se_close = strel('square',5);
se_open = strel('square',5);
bw = imclose(bw,se_open);
bw = imopen(bw,se_close);

max_area = 100/(reso^2);

[L, ~] = bwlabel(bw);
states = regionprops(L,'Area','PixelList','MajorAxisLength','MinorAxisLength');
for i = 1:size(states)
    
    % eliminate small patches less than 100 m2.
    if states(i).Area < max_area
        for j = 1:states(i).Area
            bw(states(i).PixelList(j,2),states(i).PixelList(j,1)) = 0;
        end
    end
    
    % eliminate objects that are long and thin.
    % long and thin changed objects may suffer from misregistration
    if states(i).MajorAxisLength / states(i).MinorAxisLength > 10
        for j = 1:states(i).Area
            bw(states(i).PixelList(j,2),states(i).PixelList(j,1)) = 0;
        end
    end
end

bw_frag_free = bw;
%% Correspondence Establishment

end
