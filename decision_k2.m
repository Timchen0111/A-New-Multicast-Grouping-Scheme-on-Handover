function K = decision_k2(g,UE,bwmode)
throughput = [];
sinr_array = zeros(1,length(g.joinUE));
for i = 1:length(g.joinUE)
    sinr_array(i) = UE(g.joinUE(i)).SINR;
end
for k = 1:length(g.joinUE)
    g.waitingUE = [];
    idx = kmeans(sinr_array',k);
    R = zeros(1,k);
    g.group = transpose(idx);
    groupnum = max(g.group);
    g.worstSINR = zeros(1,groupnum);
    for group_now = 1:groupnum
         ingroup = g.joinUE(find(g.group == group_now));
         worst = inf;
         for i = 1:numel(ingroup)
              if UE(ingroup(i)).SINR<worst
                   worst = UE(ingroup(i)).SINR;
              end
         end                
         g.worstSINR(group_now) = worst;
    end    
    bw = 1e8;
    %bwmode = 'fair';
    %g = bw_allocation(g,bw,bwmode);
    if bwmode == "fair"
        group_rate = zeros(1,max(g.group));
        for group = 1:max(g.group)
            SINR = g.worstSINR(group);
            if SINR == inf
                continue
            end
            SINR = 10^(SINR/10);
            group_rate(group) = log2(1+SINR);
        end
        %Calculate the ratio
        all = prod(group_rate(group_rate~=0));
        bw_ratio = zeros(1,max(g.group));
        for group = 1:length(group_rate)
            if group_rate(group) == 0
                continue
            end
            bw_ratio(group) = all/group_rate(group);
        end
        allsum = sum(bw_ratio);
        bw_allocate = (bw/allsum)*bw_ratio;
        g.bw = zeros(1,max(g.group));
        for  j = 1:length(bw_allocate)
            g.bw(j) = bw_allocate(j);
        end
    else
        if bwmode == "same"
            if isempty(g.group)
                g(i).bw = [];
                continue
            end
            count = length(find(g.worstSINR~=inf));
            g.bw = zeros(1,max(g.group));
            for j = 1:max(g.group)
                if g.worstSINR(j)~=inf
                    g.bw(j) = bw/count;
                end
            end
        else
            error("wrong use")
        end
    end
    for j = 1:k
        B = g.bw(j);
        SINR = g.worstSINR(j);
        if SINR == inf
            continue
        end
        R(j) = rate(10.^(SINR/10),B);
    end
    member_num = zeros(1,max(g.group));
    for j = 1:max(g.group)
         member_num(j) = nnz(g.group==j);
    end
    throughput(end+1) = sum(member_num.*R);
end
%disp(throughput);
K = find(throughput == max(throughput));