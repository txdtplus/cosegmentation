clear; clc; close all;

%% preprocessing
[img1,map1] = imread('data/C2009.tif','tif');
[img2,map2] = imread('data/C2012M.tif','tif');
[m,n,h] = size(img1);

img1 = double(round(img1));
img2 = double(round(img2));

N = m*n;
for i = 1:h
    h1 = imhist16(img1(:,:,i));
    h2 = imhist16(img2(:,:,i));
    CDF1 = cumsum(h1/N);
    CDF2 = cumsum(h2/N);
    a1 = find(CDF1>=0.02, 1 ) - 1;
    b1 = find(CDF1>=0.98, 1 ) - 1;
    a2 = find(CDF2>=0.02, 1 ) - 1;
    b2 = find(CDF2>=0.98, 1 ) - 1;
    img1(:,:,i) = (stepfun(img1(:,:,i),a1,b1)-a1)/(b1 - a1) * 255;
    img2(:,:,i) = (stepfun(img2(:,:,i),a2,b2)-a2)/(b2 - a2) * 255;
end

figure;
imshow(uint8(img1(:,:,4:-1:2)));
figure;
imshow(uint8(img2(:,:,4:-1:2)));
%%
% MBI1 = cal_MBI(img1);
% MBI2 = cal_MBI(img2);
load MBI;
MBI1 = MBI1/max(max(MBI1))*255;
MBI2 = MBI2/max(max(MBI2))*255;

img1 = cat(3,img1,MBI1);
img2 = cat(3,img2,MBI2);
h = h + 1;

diff_img = abs(img1 - img2);
Ic = zeros(m,n);
for i = 1:m
    for j = 1:n
        Ic(i,j) = norm(reshape(diff_img(i,j,:),[1,h]));
    end
end
h_Ic = imhist16(floor(Ic));
figure;
imshow(MBI1,[]);
figure;
imshow(MBI2,[]);
