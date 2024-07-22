function g = bw_allocation(g,bw,mode)
if mode == "fair"
    for i = 1:7
        group_rate = zeros(1,max(g(i).group));
        for group = 1:max(g(i).group)
            SINR = g(i).worstSINR(group);
            if SINR == inf
                continue
            end
            SINR = 10^(SINR/10);
            group_rate(group) = log2(1+SINR);
        end
        %Calculate the ratio
        all = prod(group_rate(group_rate~=0));
        bw_ratio = zeros(1,max(g(i).group));
        for group = 1:length(group_rate)
            if group_rate(group) == 0
                continue
            end
            bw_ratio(group) = all/group_rate(group);
        end
        allsum = sum(bw_ratio);
        bw_allocate = (bw/allsum)*bw_ratio;
        g(i).bw = zeros(1,max(g(i).group));
        for  j = 1:length(bw_allocate)
            g(i).bw(j) = bw_allocate(j);
        end
    end
else
    if mode == "same"
        for i = 1:7
            if isempty(g(i).group)
                g(i).bw = [];
                continue
            end
            count = length(find(g(i).worstSINR~=inf));
            g(i).bw = zeros(1,max(g(i).group));
            for j = 1:max(g(i).group)
                if g(i).worstSINR(j)~=inf
                    g(i).bw(j) = bw/count;
                end
            end
        end
    else
        if mode == "member"
            for i = 1:7
                if isempty(g(i).group)
                    g(i).bw = [];
                    continue
                end
                num_g = zeros(1,max(g(i).group));
                for j = 1:numel(num_g)
                    num_g(j) = numel(g(i).group(g(i).group == j));
                end
                g(i).bw = zeros(1,max(g(i).group));
                for j = 1:max(g(i).group)
                    if g(i).worstSINR(j)~=inf
                        %disp(num_g)
                        g(i).bw(j) = bw*(num_g(j)/sum(num_g));
                    end
                end
            end
        else
            error("wrong use")
        end
    end
end