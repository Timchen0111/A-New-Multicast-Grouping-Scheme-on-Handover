function k = decision_k(array)
    mode = 2;
    if mode == 1
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
    else
        if length(array) == 1
            k = 1;
            return
        end
        idx = [];
        %k = 0;
        K = length(array);
        f = zeros(1,K);
        a = zeros(1,K);
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
        f(1) = 1;
        for i = 2:K
            if i == 2
                a(i) = 1/4;
            else
                a(i) = a(i-1)+(1-a(i-1))/6;
            end
        end
        for i = 2:K
            f(i) = dsum(i)/(dsum(i-1)*a(i));
        end   
        %disp(f)
        maxk = floor(sqrt(length(f)/2));
        k = find(f == min(f(1:maxk)));
    end