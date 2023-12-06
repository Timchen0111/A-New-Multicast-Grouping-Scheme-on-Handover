function g = regrouping(g,K,allUE,type,bwmode,maxk)
    %disp('-----------------REGROUPING!------------------')
    if type == "GRPPD_uni"
        type = 'GRPPD';
    end
    if type == "GKPPD_uni"
        type = 'GKPPD';
    end
    %disp('-----------------')
    %disp(maxk)
    switch type
        case 'unicast'
            g.joinUE = g.waitingUE;
            g.waitingUE = [];
            l = numel(g.joinUE);
            g.group = 1:l;
            clear l
        case 'random'
            g.joinUE = g.waitingUE;
            g.waitingUE = [];
            l = numel(g.joinUE);
            g.group = randi(K,[1,l]);
            clear l
            
        case 'kmeans'
            g.joinUE = g.waitingUE;
            g.waitingUE = [];
            if size(g.joinUE) == 0
                return
            end
            sinr_array = zeros(size(g.joinUE));
            if numel(g.joinUE) < K
                K = numel(g.joinUE);
            end
            for i = 1: size(g.joinUE)
                sinr_array(i) = allUE(g.joinUE(i)).SINR;
            end
            sinr_array = log2(1+10.^(sinr_array./10));
            idx = kmeans(transpose(sinr_array),K);
            g.group = transpose(idx);
            
        case 'GRPPD'
            g.group = [];
            scnum = numel(g.joinUE);
            g.joinUE = [g.waitingUE g.joinUE];
            g.waitingUE = [];
            l = numel(g.joinUE)-scnum;
            g.group = randi(K,[1,l]);
            scg(1:scnum) = K+1;
            g.group = [g.group scg];
            clear l
        case 'GKPPD'
            if size(g.waitingUE) == 0
                return
            end            
            g.group = [];
            scnum = numel(g.joinUE);
            g.joinUE = [g.waitingUE g.joinUE];           
            l = numel(g.waitingUE);%change
            sinr_array = zeros(l,1);
            g.waitingUE = [];             
           
            for i = 1:l
                sinr_array(i) = allUE(g.joinUE(i)).SINR;
            end
            siz = size(sinr_array);
            if siz(1) < K
                K = siz(1);
            end
            sinr_array = log2(1+10.^(sinr_array./10));
            idx = kmeans(sinr_array,K);
            scg(1:scnum) = maxk+1;
            g.group = transpose(idx);
            g.group = [g.group scg];
        case  'dynamic_k'            
            if size(g.waitingUE) == 0
                return
            end            
            g.group = [];
            scnum = numel(g.joinUE);
            g.joinUE = [g.waitingUE g.joinUE];           
            l = numel(g.waitingUE);%change
            sinr_array = zeros(l,1);
            g.waitingUE = [];             
           
            for i = 1:l
                sinr_array(i) = allUE(g.joinUE(i)).SINR;
            end
            siz = size(sinr_array);
            if siz(1) < K
                K = siz(1);
            end
            sinr_array = log2(1+10.^(sinr_array./10));
            idx = kmeans(sinr_array,K);
            scg(1:scnum) = K+1;
            g.group = transpose(idx);
            
            groupnum = max(g.group);
            g.worstSINR = zeros(1,groupnum);
            for group_now = 1:groupnum
                ingroup = g.joinUE(find(g.group == group_now));
                worst = inf;
                for i = 1:numel(ingroup)
                    if allUE(ingroup(i)).SINR<worst
                        worst = allUE(ingroup(i)).SINR;
                    end
                end
                g.worstSINR(group_now) = worst;
            end

            a = g.worstSINR;
            a(a==inf) = [];
            a = log2(1+10.^(a./10));         
            member_num = zeros(1,max(g.group));
            for j = 1:length(a)
                 member_num(j) = nnz(g.group==j);
            end
            member_num(member_num==0) = [];
            check = zeros(1,length(a)-1);
            a_s = sort(a);
            Sort = zeros(1,length(a));
            scount = 1;
            for i = 1:length(a)
                f = find(a==a_s(i));
                Sort(i) = f(scount);
                if scount<length(f)
                    scount = scount+1;
                else
                    scount = 1;
                end 
            end
            mergecount = length(check)+1;
            grnow = Sort(1);
            for i = 1:length(check)
                %check(i) = (a(Sort(i+1))/a(grnow))/((mergecount/(mergecount-1))+member_num(grnow)/member_num(Sort(i+1)));
                left = a(Sort(i+1))/a(grnow);
                a2 = a;
                a(grnow) = inf;
                a(Sort(i+1)) = inf;
                a_other = min(a);
                a = a2;
                m_other = sum(member_num)-member_num(grnow)-member_num(Sort(i+1));
                right = 1+(1/mergecount)*(1+member_num(grnow)/member_num(Sort(i+1))+a_other*m_other/(a(grnow)*member_num(Sort(i+1))));
                if left<right
                    disp('--------------------MERGING---------------------')
                    disp(i)
                    g.group(g.group==Sort(i+1)) = grnow;
                    member_num(Sort(grnow)) = member_num(Sort(i+1)) + member_num(Sort(grnow));
                    member_num(Sort(i+1)) = 0;
                    mergecount = mergecount-1;
                else
                    grnow = Sort(i+1);
                end
            end
            g.group = [g.group scg];

        case  'dynamic_k2' %Upper bound
            if size(g.waitingUE) == 0
                return
            end            
            g.group = [];
            scnum = numel(g.joinUE);
            g.joinUE = [g.waitingUE g.joinUE];           
            l = numel(g.waitingUE);%change
            sinr_array = zeros(l,1);
            g.waitingUE = [];                    
            for i = 1:l
                sinr_array(i) = allUE(g.joinUE(i)).SINR;
            end
            sinr_array = log2(1+10.^(sinr_array./10));
            K = decision_k2(g,allUE,bwmode);
            idx = kmeans(sinr_array,K);
            scg(1:scnum) = K+1;
            g.group = transpose(idx);
            g.group = [g.group scg];
            g.groupnum = K;
        case 'CQI'
            g.joinUE = g.waitingUE;
            g.waitingUE = [];
            g.group = [];
            for i = 1:length(g.joinUE)
                g.group(end+1) = CQI_mapping(allUE(g.joinUE(i)).SINR);
            end
            g.groupnum = 15;
    end