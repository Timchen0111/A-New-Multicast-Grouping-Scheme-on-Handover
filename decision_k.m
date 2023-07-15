function k = decision_k(array)
    if length(array) == 1
        k = 1;
        return
    end
    idx = [];
    %k = 0;
    K = length(array);
    dsum = zeros(1,K);
    for i = 1:K
        idx(i,:) = kmeans(array,i);
        for j = 1:i
            member = array(find(idx(i,:)==j));
            center = mean(member);
            dist = sum((member-center).^2);
            dsum(i) = dsum(i)+dist;
        end
    end
    %disp(idx)
    %figure(1)
    %plot(1:K,dsum)
    x = dsum(1);
    y = dsum(K);
    
    vector1 = [K-1,y-x];
    dist2 = zeros(1,K);
    for i = 1:K
        vector2 = [i-1,dsum(i)-x];
        proj = dot(vector1,vector2)/norm(vector1);
        dist2(i) = sqrt(norm(vector2)^2-proj^2);
    end
    k = find(dist2 == max(dist2));
    if length(k)>1
        k = k(1);
    end