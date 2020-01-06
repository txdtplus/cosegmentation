clear;clc;close all;

imds = imageDatastore('D:\data\GAMMA_fil','FileExtensions',{'.bmp'});
img_num = length(imds.Files);

for i = 1:1
    for j = i+7
        [img1,map1] = imread(imds.Files{i},'bmp');
        [img2,map2] = imread(imds.Files{j},'bmp');
        img1 = double(round(img1));
        img2 = double(round(img2));
        
        Ic = img_diff(img1,img2);
        I_v = reshape(Ic,1,[]);
        
        Ic_hist = imhist16(Ic)/1e6;
        figure;
        stem(Ic_hist,'.')
        grid on
        
        %% zhishu distribution
        hold on
        x = 0:0.1:255;
        lambda = 1/mean(mean(Ic));
        f_e = f_exp(x,lambda);
        plot(x,f_e,'LineWidth',2);
        legend('hist','exp');
        title(['img',num2str(i),' and img',num2str(j),''])
        fprintf('the %d and %d diff\n',i,j);
        saveas(gcf,['D:\image\',num2str(i),'and',num2str(j),''],'png');
        hold off;
    end
end


%% contrast
pix = 0:(length(Ic_hist)-1);
diff_hist = Ic_hist - f_exp(pix,lambda);
figure;
stem(diff_hist(2:end))
title(['img',num2str(i),' and img',num2str(j),''])
grid on;


function y = f_exp(x,lambda)
y = lambda*exp(-lambda*x);
end