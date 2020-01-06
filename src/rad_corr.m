function img_out = rad_corr(img,t_min,t_max)

[m,n,h] = size(img);
N = m*n;
for i = 1:h
    h = imhist16(img(:,:,i));
    CDF = cumsum(h/N);
    a = find(CDF> t_min, 1 ) - 1;
    b = find(CDF>=t_max, 1 ) - 1;
    img(:,:,i) = (stepfun(img(:,:,i),a,b)-a)/(b - a) * 255;
end
img_out = img;
end


function y = stepfun(x,a,b)
y = x;
y(y<a) = a;
y(y>b) = b;
end
