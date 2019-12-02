% %% create mask
% % for i = 1:h
% %     img2(:,:,i) = img2(:,:,i)./max(max(img1(:,:,i)));
% %     img1(:,:,i) = img1(:,:,i)./max(max(img1(:,:,i)));
% % end
% % figure;
% % imshow(img1(:,:,3:-1:1))
% % figure;
% % imshow(img2(:,:,3:-1:1))
% % ROI = cell(1,2);
% % for i = 1:2
% %     h = drawfreehand();
% %     ROI{i} = h.createMask();
% % end
% % mask = ROI{1} | ROI{2};
% 
% load mask
% k = zeros(h,1);
% b = zeros(h,1);
% 
% img1_corr = img1;
% img1_mask = img1.*mask;
% img2_mask = img2.*mask;
% img1_v = reshape(img1_mask,m*n,h);
% img2_v = reshape(img2_mask,m*n,h);
% img1_v(all(img1_v==0,2),:) = []; 
% img2_v(all(img2_v==0,2),:) = [];
% one = ones(length(img1_v),1);
% contrast1 = [img1_v,img2_v];
% figure(1)
% plot(contrast1(:,1),contrast1(:,5),'.');
% figure(2)
% plot(contrast1(:,2),contrast1(:,6),'.');
% figure(3)
% plot(contrast1(:,3),contrast1(:,7),'.');
% figure(4)
% plot(contrast1(:,4),contrast1(:,8),'.');
% for i = 1:h
%     A = [img1_v(:,i),one];
%     y = img2_v(:,i);
%     x = pinv(A)*y;
%     k(i) = x(1);
%     b(i) = x(2);
%     img1_corr(:,:,i) = img1(:,:,i)*k(i) + b(i);
% end
% 
% for i = 1:h
%     img2(:,:,i) = img2(:,:,i)./max(max(img2(:,:,i)));
%     img1_corr(:,:,i) = img1_corr(:,:,i)./max(max(img1_corr(:,:,i)));
% end
% figure;
% imshow(img1_corr(:,:,3:-1:1))
% figure;
% imshow(img2(:,:,3:-1:1))

% img1_corr_v = reshape(img1_corr.*mask,m*n,h);
% img1_corr_v(all(img1_corr_v==0,2),:) = []; 
% img2_mask = img2.*mask;
% img2_v_ = reshape(img2_mask,m*n,h);
% img2_v_(all(img2_v_==0,2),:) = [];
% contrast2 = [img1_corr_v,img2_v_];

% a2 = img2(:,:,2).*mask + 0.04;
% a1 = img1_corr(:,:,2).*mask;

% figure;
% imshow(img1(:,:,3:-1:1))
% figure;
% imshow(img2(:,:,3:-1:1))
% 
% load mask;
% a2 = img2.*mask;
% a1 = img1.*mask;
% img1_v = reshape(a2,m*n,h);
% img2_v = reshape(a1,m*n,h);
% img1_v(all(img1_v==0,2),:) = []; 
% img2_v(all(img2_v==0,2),:) = [];
% contrast = [img1_v,img2_v];
% a = img1(:,:,1);