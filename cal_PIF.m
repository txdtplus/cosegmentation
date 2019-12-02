function PIF = cal_PIF(img)

NDVI = (img(:,:,4)-img(:,:,3))./(img(:,:,4)+img(:,:,3));
NDWI = (img(:,:,2)-img(:,:,4))./(img(:,:,2)+img(:,:,4));

% hsv1 = rgb2hsv(img(:,:,3:-1:1));
% hsv2 = rgb2hsv(img2(:,:,3:-1:1));
% NIR_R_Ratio_1 =  img(:,:,4)./img(:,:,1);
% NIR_R_Ratio_2 =  img2(:,:,4)./img2(:,:,1);

NDVI(NDVI>0.15) = 0;
NDVI(NDVI~=0) = 1;

NDWI(NDWI>0.15) = 0;
NDWI(NDWI~=0) = 1;

PIF = NDVI .* NDWI;
end

