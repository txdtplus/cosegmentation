function bw_out = frag_remove(bw,reso)
% fragmentation removal

se_close=strel('square',3);
se_open=strel('square',3);

bw=imclose(bw,se_open);
bw=imopen(bw,se_close);
bw_out = bwareaopen(bw, 100/(reso^2)); % eliminate small patches less than 100 m2
end

