function MBI = cal_MBI(img)
% calculate MBI of the input image

img_double = double(img);
[M,N,~] = size(img);
b = max(img_double,[],3);              % b is brightness image
smin = 0;  smax = 800;  ds = 100;
S = (smax - smin)/ds + 1;
D = 10;

MP1 = repmat(b,[1,1,D]);
MP2 = MP1;
DMP = zeros(M,N,S);
i = 1;
for s = smin : ds : smax
    disp(['calculating DMP... the ',num2str(i),'th loop']);
    j = 1;
    for d = 0 : pi/(D-1) : pi
        disp(['calculating direction... the ',num2str(j),'th loop']);
        SE = strel('line',s,d);        % structral element
        be = imerode(b,SE);            % erosion      
        gamma = imreconstruct(be, b);  % open by reconstruction
        WTH = b - gamma;
        MP2(:,:,j) = WTH;
        j = j + 1;
    end
    DMP(:,:,i) = mean(abs(MP2 - MP1),3);
    MP1 = MP2;
    i = i + 1;
end
MBI = mat2gray(mean(DMP,3));
disp('MBI calculation finished!');
disp(' ');
end

