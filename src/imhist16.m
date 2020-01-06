function h = imhist16(img)
% calculate hist for 16 bit image
% img should be a gray image
% pixel value should be integer

img = ceil(img);
[m,n] = size(img);
max_v = max(max(img));
l = max_v + 1;
h = zeros(1,l);
img = img + 1;
for i = 1:m
    for j = 1:n
        h(img(i,j)) = h(img(i,j)) + 1;
    end
end

end

