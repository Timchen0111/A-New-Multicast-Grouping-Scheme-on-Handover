function k = decision_k(array,K)
    idx = [];
    %k = 0;
    dsum = zeros(1,K);
    for i = 1:K
        idx(i,:) = kmeans(array',i);
        for j = 1:i
            member = array(find(idx(i,:)==j));
            center = mean(member);
            dist = sum((member-center).^2);
            dsum(i) = dsum(i)+dist;
        end
    end
    %disp(idx)
    figure(1)
    plot(1:K,dsum)
    x = dsum(1);
    y = dsum(K);

    