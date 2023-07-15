function g = regrouping(g,K,allUE,type)
    %random give
    %disp('-----------------REGROUPING!------------------')
    if type == "GRPPD_uni"
        type = 'GRPPD';
    end
    if type == "GKPPD_uni"
        type = 'GKPPD';
    end
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
            idx = kmeans(sinr_array,K);
            scg(1:scnum) = K+1;
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
            %siz = size(sinr_array);
            %if siz(1) < K
            %   K = siz(1);
            %end
            K = decision_k(sinr_array,length(g.joinUE));
            idx = kmeans(sinr_array,K);
            scg(1:scnum) = K+1;
            g.group = transpose(idx);
            g.group = [g.group scg];
     end