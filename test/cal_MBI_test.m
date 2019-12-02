clear; clc; close all;
[img,map] = imread('data/C2009.tif','tif');
img_double = double(img);

b = max(img_double,[],3);              % b is brightness image
smin = 10;  smax = 70;  ds = 5;
S = (smax - smin)/ds + 1;
D = 4;
n = D*S;

MP1 = b;
DMP = cell(1,n);
sum_DMP = 0;
i = 1;
for s = smin : ds : smax
    for d = 0 : pi/(D-1) : pi
        SE = strel('line',s,d);         % structral element
        b_e = imerode(b,SE);            % erosion
        gamma = imreconstruct(b_e, b);  % open by reconstruction
        WTH = b - gamma;
        MP2 = WTH;
        
        DMP{i} = abs(MP2 - MP1);       
        MP1 = MP2;
        disp(['the ',num2str(i),'th loop']);
        sum_DMP = sum_DMP + DMP{i};
        i = i + 1;
    end
end
MBI = sum_DMP / n;

% figure;
% imshow(b,map);
% 
% figure;
% imshow(MBI,map);
% 
% 
% for i = 1:4
%     img_double(:,:,i) = img_double(:,:,i)/max(max(img_double(:,:,i)));
% end
% 
% figure;
% imshow(img_double(:,:,[3,2,1]),'DisplayRange',[])
