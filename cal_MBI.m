function MBI = cal_MBI(img)
% calculate MBI of the input image

img_double = double(img);

b = max(img_double,[],3);              % b is brightness image
smin = 10;  smax = 70;  ds = 5;
S = (smax - smin)/ds + 1;
D = 10;  n = D*S;

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
        disp(['calculating MBI... the ',num2str(i),'th loop']);
        sum_DMP = sum_DMP + DMP{i};
        i = i + 1;
    end
end
MBI = sum_DMP / n;
disp('MBI calculation finished!');
disp(' ');
end

