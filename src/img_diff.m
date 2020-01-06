function Ic = img_diff(img1,img2)

[m,n,h] = size(img1);
% diff_img = abs(img1 - img2);
diff_img = (img1 - img2);
Ic = zeros(m,n);
for i = 1:m
    for j = 1:n
        Ic(i,j) = norm(reshape(diff_img(i,j,:),[1,h]));
        %         Ic(i,j) = (reshape(diff_img(i,j,:),[1,h]));
    end
end
end

