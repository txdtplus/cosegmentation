function V_pq = Vpq(img,dist,nlink_graph)
% calculate V{p,q}. V{p,q} represents the penalty
% for a discontinuity between pixels p and q

H = size(img,3);
numEdges = length(dist);
diff_IpIq_square = zeros(numEdges,1);
fprintf('\n\n\ncalculating Vpq ...\n\n');

for i = 1:numEdges
    diff_IpIq = img(nlink_graph(i,1),nlink_graph(i,2),:) - ...
        img(nlink_graph(i,3),nlink_graph(i,4),:);
    diff_IpIq = reshape(diff_IpIq,[H,1]);
    diff_IpIq_square(i) = diff_IpIq'*diff_IpIq;
    if mod(i,5e5) == 0
        fprintf('%dth calculation finished!\n',i);
    end
end

sigma_square = mean(diff_IpIq_square);

V_pq = exp(-diff_IpIq_square/(2*sigma_square))./dist;
end

