function g = bw_allocation(g,bw)
for i = 1:7
    g(i)
    group_rate = zeros(1,max(g(i).group));
    for group = 1:max(g(i).group)
        SINR = g(i).worstSINR(group);
        if SINR == inf
            continue
        end
        SINR = 10^(SINR/10);
        group_rate(group) = log2(1+SINR);
    end
    %disp(group_rate)
    %disp('------------------------------------------------')
    %Calculate the ratio
    all = prod(group_rate(group_rate~=0));
    bw_ratio = zeros(1,max(g(i).group));
    %bw_allocate = zeros(1,max(g(i).group));
    for group = 1:length(group_rate)
        if group_rate(group) == 0
            continue
        end
        bw_ratio(group) = all/group_rate(group);
    end
    allsum = sum(bw_ratio);
    bw_allocate = (bw/allsum)*bw_ratio;
    g(i).bw = bw_allocate;
end