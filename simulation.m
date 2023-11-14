function report = simulation(UE_num,time,dropnum,dropout,K,mode,pptimer,handover,bwmode,groupsize)
%Scheme: Add Ping-Pong Detection on grouping
maxk = K;
if mode == "GRPPD" || mode == "GRPPD_uni" || mode == "GKPPD" || mode == "GKPPD_uni" || mode == "dynamic_k2" || mode == "dynamic_k"
    GRPPD = true;
else
    GRPPD = false;
end
if mode == "GRPPD_uni"
    uni = true;
else
    if mode == "GKPPD_uni"
        uni = true;
    else
        uni = false;
    end
end

skipr = false;

%groupsize = 2;

if mode == "dynamic_k2"
    K = UE_num;
end

%disp(size(fad_map))

all_throughput = 0;
%pingpongarray = zeros(UE_num,1)

Regroup_count = 0;
%ggnum = zeros(1,100);
pingpong_time = pptimer;
staytime = zeros(1,UE_num);
sctime = zeros(1,UE_num);
success = zeros(1,UE_num);
fail = zeros(1,UE_num);
stay_sinr = 0;
sc_sinr = 0;
tic; %Fix grouping.

UE.num = 0;
UE.pos = [0,0];
UE.now_gNB = 0;
UE.velocity = [0,0];
UE.SINR = 0;
UE.change_admission = false;
UE.pptimer = 0;
UE.ppsave = [];
UE.ppDrop = false;
UE.state = 0;

gNB.num = 0;
gNB.pos = [inf,inf];
gNB.joinUE = [];
gNB.waitingUE = [];
gNB.scUE = [];
gNB.group = []; 
gNB.worstSINR = zeros(K);
gNB.std = 0;
if GRPPD ==false
    groupnum = K;
else
    groupnum = K+1;
end
if mode == "unicast"
    groupnum = UE_num;
end
for i=1:19
    gNB(i).pos = [inf,inf];
    gNB(i).worstSINR = inf;
end

gNB = set_gNB(gNB,UE_num,K);

bw = 1e8;
noise = -174+10*log10(bw); %db
fixed = 0;
for i=1:(UE_num+fixed)
    X = [inf,inf];
    while boundary(X(1),X(2),gNB) == false
        X = 1000*rand(2,1)-500;
    end
    UE(i).num = i;
    UE(i).pos = X;%generate random initial position of UEs
    now_ = now_gNB(UE(i),gNB,noise,handover);
    UE(i).now_gNB = now_(1);
    UE(i).SINR = now_(2);
    UE(i).change_admission = false;
    UE(i).pptimer = -1;
    UE(i).ppsave = [];
    UE(i).state = 0;
    gNB(UE(i).now_gNB) = add_remove(gNB(UE(i).now_gNB),UE(i),1);
end

%Set velocity
for i=1:UE_num
    UE(i).velocity = velocity(UE(i).pos,UE(i).velocity,gNB);
end

%fading map

change = 0;

for i=1:UE_num
    pos = UE(i).pos;
    x(i) = pos(1);
    y(i) = pos(2);
end

if fixed ~= 0
    for i = (UE_num+1):(UE_num+fixed)
        pos = UE(i).pos;
        x(i) = pos(1);
        y(i) = pos(2);
    end
end

for i=1:19
    x(end+1) = gNB(i).pos(1);
    y(end+1) = gNB(i).pos(2);
end

figure(1)
c = gNB_color(UE);
scatter(x,y,[],c)
clear x y

%Loop
for i = 1:7
     gNB(i); 
end

item = 0;
faditem = 1;
for t=1:time %600 %1 minutes Unit:100ms
    T = 10*t;
    item = item+1;

    %Only change grouping on t%10 = 0
    
    if t == 1
        for i = 1:7 
            if groupsize > 0
                KK = max(1,floor(numel(gNB(i).waitingUE)/groupsize));
            else 
                KK = K;
            end
            gNB(i) = regrouping(gNB(i),KK,UE,mode,bwmode,K);
        end
    end
    if rem(t,10) == 0
        skip = false;
    else
        skip = true;
    end
    
    %Moving stage 
    %disp('--------move stage-------')
    for i=1:UE_num
        %move
        for j=1:2
            UE(i).pos(j) = UE(i).pos(j)+UE(i).velocity(j);
        end
        %check boundary
        if boundary(UE(i).pos(1),UE(i).pos(2),gNB) == false
            v = UE(i).velocity;
            UE(i).velocity = velocity(UE(i).pos,v,gNB);
        end
             
        %check nowgNB
        %-------------------ADDING PINGPONG(3/23)---------------------
        %disp(UE(i).pptimer)
        %The algorithm there is based on "Reducing Ping-Pong Handover Effects In Intra EUTRA Networks".
        old = UE(i).now_gNB;
        Now = now_gNB(UE(i),gNB,noise,handover);
        now = Now(1);
        UE(i).SINR = Now(3);

        if UE(i).pptimer>-1 && UE(i).pptimer<pingpong_time
            UE(i).pptimer = UE(i).pptimer+1;
            %disp('--------------Handover Preparation--------------')
        end

        if old ~= now && UE(i).pptimer == -1
            UE(i).pptimer = 0; %Start SC event
            UE(i).state = 1;
            UE(i).ppsave = now;
        else
            if UE(i).pptimer == -1
                %disp('--------------Stay in gNB--------------')
                staytime(1,i) = staytime(1,i)+1;
                stay_sinr = ((sum(staytime)-1)*stay_sinr+UE(i).SINR)/sum(staytime);
            else
                sctime(1,i) = sctime(1,i)+1;
                sc_sinr = ((sum(sctime)-1)*sc_sinr+UE(i).SINR)/sum(sctime);                
            end
        end
        
        %detect pingpong
            if UE(i).pptimer<pingpong_time
                UE(i).change_admission = false;
            else
                %disp('---------------time expired------------.')
                if UE(i).ppsave == now
                    UE(i).change_admission = true;
                    %disp('----------Setting new gNB-----------')
                    success(i) = success(i)+1;
                    UE(i).ppsave = [];
                    UE(i).pptimer = -1;
                else
                    %disp('------------PINGPONG happened----------------')
                    UE(i).change_admission = false;
                    fail(i) = fail(i)+1; 
                    UE(i).ppsave = now;
                    UE(i).pptimer = 0;
                end
            end
            %Change nowgNB
            if UE(i).change_admission == true
                UE(i).state = 0;
                change = change+1;
                UE(i).now_gNB = now;
                UE(i).SINR = Now(2);
                gNB(old) = add_remove(gNB(old),UE(i),2);
                if numel(find(gNB(old).waitingUE == i))>0
                    rem_waiting = find(gNB(old).waitingUE == i);
                    gNB(old).waitingUE(rem_waiting) = []; 
                end
                gNB(UE(i).now_gNB) = add_remove(gNB(UE(i).now_gNB),UE(i),1);
            end
    end
    
    % if skip == true
    %     continue
    % end
    
    %Update worst SINR
    for index = 1:7
        if mode == "dynamic_k" || mode == "dynamic_k2"
            groupnum = gNB(index).groupnum+1;
        end
        for group_now = 1:groupnum
            ingroup = gNB(index).joinUE(find(gNB(index).group == group_now));
            worst = inf;
            for i = 1:numel(ingroup)
                if UE(ingroup(i)).SINR<worst
                    worst = UE(ingroup(i)).SINR;
                end
            end
            gNB(index).worstSINR(group_now) = worst;
        end
    end
    %drop out stage
    %disp('--------dropout stage-------')
    drop_num = zeros(1,7);
    for i = 1:7      
        if skip == true
            continue
        end
        disp(t)
        if mode == "dynamic_k2"
            K = gNB(i).groupnum;
        end
        
        for group_now = 1:K
            drop_out = [];
            scgroup = [];
            ingroup = gNB(i).joinUE(find(gNB(i).group == group_now));
            if numel(ingroup) == 0
                continue
            end
            for j = 1:numel(ingroup)
                sinr(j) = UE(ingroup(j)).SINR;
                ppDrop(j) = UE(ingroup(j)).pptimer;
                UE(ingroup(j)).ppDrop = false;
            end
            mean(sinr);
            for j = 1:numel(ingroup)
                if abs(sinr(j)-mean(sinr)) > dropout && ppDrop(j) == -1
                    drop_out(end+1) = ingroup(j); %Record UEs be dropped out
                end         
                if ppDrop(j) > -1 && GRPPD == true
                    scgroup(end+1) = ingroup(j);
                end
            end           
            for k = 1:numel(drop_out)                
                index = drop_out(k);
                gNB(UE(index).now_gNB) = add_remove(gNB(UE(index).now_gNB),UE(index),2);
                gNB(UE(index).now_gNB) = add_remove(gNB(UE(index).now_gNB),UE(index),1);
                drop_num(i) = drop_num(i)+1;
            end
            for k = 1:numel(scgroup)
                index = scgroup(k);
                gNB(UE(index).now_gNB) = add_remove(gNB(UE(index).now_gNB),UE(index),2);
                gNB(UE(index).now_gNB) = add_remove(gNB(UE(index).now_gNB),UE(index),3);
            end
        end
    end

    for i = 1:7
        if drop_num(i) > dropnum            
            regroup(i) = true;
        else
            regroup(i) = false;
        end
    end
    %disp('--------to SC group stage-------')
        if GRPPD == true
            if uni == false
                for i = 1:7
                    if mode == "dynamic_k2"
                        K = gNB(i).groupnum;
                    end
                    gNB(i).joinUE = [gNB(i).joinUE gNB(i).scUE];
                    scnum = numel(gNB(i).scUE);
                    gNB(i).scUE = [];
                    sc(1:scnum) = K+1; 
                    gNB(i).group = [gNB(i).group sc];
                    sc = [];
                end
            else
                for i = 1:7
                    gNB(i).joinUE = [gNB(i).joinUE gNB(i).scUE];
                    scnum = numel(gNB(i).scUE);
                    gNB(i).scUE = [];
                    if scnum ~=0
                        sc = K+1:K+scnum;
                    else
                        sc = [];
                    end
                    gNB(i).group = [gNB(i).group sc];     %problem
                    sc = [];
                    gNB(i).groupnum = gNB(i).groupnum+scnum;
                end
            end
        end
    %add UE stage

    %disp('--------AddUE Stage-------')
        %Add UE
        %Update worst SINR
        for index = 1:7
            if isempty(gNB(index).joinUE)
                gNB(index).worstSINR = [];
                continue
            end
            groupnum = max(gNB(index).group);
            for group_now = 1:groupnum
                ingroup = gNB(index).joinUE(find(gNB(index).group == group_now));
                worst = inf;
                for i = 1:numel(ingroup)
                    if UE(ingroup(i)).SINR<worst
                        worst = UE(ingroup(i)).SINR;
                    end
                end                
                gNB(index).worstSINR(group_now) = worst;
            end
            gNB(index).worstSINR(groupnum+1:end) = [];
        end

       for index = 1:7
            if mode == "dynamic_k2"
                K = gNB(index).groupnum;
            end
            if regroup(index) == false
                if uni == false
                    for i = 1:numel(gNB(index).waitingUE)
                        UE_be_added = gNB(index).waitingUE(i);
                        sinr = [];
                        sinr(1:length(gNB(index).worstSINR)) = UE(UE_be_added).SINR;
                        diff = sinr-gNB(index).worstSINR;
                        if length(diff)<K
                            diff(length(diff)+1:K) = -inf;
                        end
                        if mode ~= "unicast"
                            diff = diff(1:K);
                        end
                        if max(diff)>0
                            add_group = find(diff == min(diff(diff>0)));
                        else
                            if min(diff) == -inf
                                empty = find(diff == min(diff));
                                add_group = empty(1);
                            else
                                add_group = find(diff==max(diff));
                            end                        
                        end                     
                        start_sc = min(find(gNB(index).group==(K+1)));%PROBLEM!!!
                        if numel(start_sc) ~= 0 && GRPPD == true                        
                            gNB(index).joinUE = [gNB(index).joinUE(1:start_sc-1) UE_be_added gNB(index).joinUE(start_sc:end)];
                            gNB(index).group = [gNB(index).group(1:start_sc-1) add_group gNB(index).group(start_sc:end)];
                        else
                            
                            gNB(index).joinUE = [gNB(index).joinUE UE_be_added];
                            gNB(index).group = [gNB(index).group add_group];
                        end
                    end
                    gNB(index).waitingUE = [];
                else
                    for i = 1:numel(gNB(index).waitingUE)
                        UE_be_added = gNB(index).waitingUE(i);
                        sinr = [];
                        sinr(1:length(gNB(index).worstSINR)) = UE(UE_be_added).SINR;
                        diff = sinr-gNB(index).worstSINR;
                        if length(diff) < K
                            diff(length(diff)+1:K) = -inf;
                        end                      
                        diff = diff(1:K);
                        if max(diff)>0
                            add_group = find(diff == min(diff(diff>0)));
                        else
                            if min(diff) == -inf
                                empty = find(diff == min(diff));
                                add_group = empty(1);
                            else
                                add_group = find(diff==max(diff));
                            end                        
                        end
                        
                        start_sc = min(find(gNB(index).group>K));%PROBLEM!!!
                        if numel(start_sc) ~= 0
                            gNB(index).joinUE = [gNB(index).joinUE(1:start_sc-1) UE_be_added gNB(index).joinUE(start_sc:end)];
                            gNB(index).group = [gNB(index).group(1:start_sc-1) add_group gNB(index).group(start_sc:end)];
                        else
                            gNB(index).joinUE = [gNB(index).joinUE UE_be_added];
                            gNB(index).group = [gNB(index).group add_group];
                        end
                    end
                    gNB(index).waitingUE = [];
                end              
            end           
        end

        if mode == "unicast"
            for i = 1:7
                regroup(i) = false;
                gNB(i).group = 1:length(gNB(i).joinUE);
            end
        end
        if skipr == false && skip == false
            %disp('-----------Regrouping Stage----------')        
            for i = 1:7
                if regroup(i) == true
                    Regroup_count = Regroup_count+1;
                    if GRPPD == true
                        scnum = numel(find(gNB(i).group==(K+1)));
                    else
                        scnum = 0;
                    end
                    endd = numel(gNB(i).joinUE)-scnum;
                    ue_array = gNB(i).joinUE(1:endd);                
                    for j = 1:numel(ue_array)
                        ue = ue_array(j);
                        gNB(i) = add_remove(gNB(i),UE(ue),2);
                        gNB(i) = add_remove(gNB(i),UE(ue),1);
                    end
                    if groupsize > 0
                        KK = max(1,floor(numel(gNB(i).waitingUE)/groupsize));
                    else 
                        KK = K;
                    end
                    
                    
                    gNB(i) = regrouping(gNB(i),KK,UE,mode,bwmode,K);     
                    %ggnum(gNB(i).groupnum) = ggnum(gNB(i).groupnum)+1;
                end
            end
        end
        
        if uni == true
            %Grouping index adjustment
            for index = 1:7
                scindex = min(find(gNB(index).group>K));
                if  min(gNB(index).group)>K
                    scgroup = gNB(index).group;
                    gNB(index).group = [];
                else
                    scgroup = gNB(index).group(scindex:end);
                    gNB(index).group(scindex:end) = [];
                end
                for i = 1:numel(scgroup)
                    scgroup(i) = K+i;
                end
                gNB(index).group = [gNB(index).group scgroup];
                gNB(index).groupnum = max(gNB(index).group);
                if numel(gNB(index).groupnum) == 0 || gNB(index).groupnum<K
                    gNB(index).groupnum = K;
                end
                gNB(index).worstSINR(gNB(index).groupnum+1:end) = [];
            end
        end

        %Update worst SINR
        for index = 1:7
            if isempty(gNB(index).joinUE)
                gNB(index).worstSINR = [];
                continue
            end
            groupnum = max(gNB(index).group);
            for group_now = 1:groupnum
                ingroup = gNB(index).joinUE(find(gNB(index).group == group_now)); %BUGBUGBUG
                worst = inf;
                for i = 1:numel(ingroup)
                    if UE(ingroup(i)).SINR<worst
                        worst = UE(ingroup(i)).SINR;
                    end
                end                
                gNB(index).worstSINR(group_now) = worst;
            end
            gNB(index).worstSINR(groupnum+1:end) = [];
            gs = gNB(index).worstSINR;
            gs(gs==inf)=[];
            gNB(index).groupnum = length(gs);
        end
        
        %Bandwidth Allocation

        gNB = bw_allocation(gNB,bw,bwmode);

        %Calculate efficiency
        if mode == "unicast"
            for i = 1:7
                worstSINR2 = gNB(i).worstSINR;
                worstSINR2((worstSINR2==inf)) = [];
                if ~isempty(worstSINR2)
                    R = zeros(1,length(gNB(i).joinUE));
                    for j = 1:length(gNB(i).joinUE)
                        B = gNB(i).bw(j);
                        SINR = gNB(i).worstSINR(j);
                        R(j) = rate(10.^(SINR/10),B);
                    end
                    throughput = sum(R); 
                    all_throughput = all_throughput + throughput;
                end
            end
        else
            for i = 1:7
                member_num = zeros(1,max(gNB(i).group));
                for j = 1:max(gNB(i).group)
                    member_num(j) = nnz(gNB(i).group==j);
                end
                if uni == true
                    if groupnum>K
                        for j = K+1:length(member_num)
                            member_num(j) = 1;
                        end
                    end
                end
                R = zeros(1,length(member_num));
                %disp(sum(member_num))
                for j = 1:length(member_num)
                    B = gNB(i).bw(j);
                    SINR = gNB(i).worstSINR(j);
                    if SINR == inf
                        continue
                    end
                    R(j) = rate(10.^(SINR/10),B);
                end
                throughput = sum(member_num.*R);
                if ~isempty(gNB(i).worstSINR)
                    all_throughput = all_throughput + throughput;
                end  
                
            end    
        end
    
end
disp('----------------------REPORT----------------------')
sc_rate = sctime./(sctime+staytime);
sc_ratio = sc_rate(1);
%fail_rate = fail./(success+fail);
% all_fail_rate = sum(fail)./(sum(success)+sum(fail))
%plotgraph(sc_rate,fail_rate)
% pingpong_rate = all_fail_rate.*sc_ratio
% disp('stay_sinr')
% disp(stay_sinr)
% disp('sc_sinr')
% disp(sc_sinr)
%std_ = [0 0 0 0 0 0 0];
for i = 1:7
    % The following code is for a new method%
     a = gNB(i).worstSINR;
     a(a==inf) = [];
     a = log2(1+10.^(a./10));
     a = sort(a);
     member_num = zeros(1,max(gNB(i).group));
     for j = 1:max(gNB(i).group)
         member_num(j) = nnz(gNB(i).group==j);
     end
     member_num(member_num==0) = [];
     check = zeros(1,length(a)-1);
     if length(a) >= 1
         for k = 1:length(a)-1
             check(k) = (a(k+1)/a(k))/(2+member_num(k)/member_num(k+1));
         end
         gNB(i).std = check;
     else
         gNB(i).std = [];
     end
    % The following code is for a new method%
     gNB(i)
end

for i=1:(UE_num+fixed)
    pos = UE(i).pos;
    x(i) = pos(1);
    y(i) = pos(2);
end
for i=1:19
    x(end+1) = gNB(i).pos(1);
    y(end+1) = gNB(i).pos(2);
end

figure(2)
c = gNB_color(UE);
scatter(x,y,[],c)
% for i = 1:numel(UE)
%     UE(i).pos
%     UE(i).SINR
% end
%UE.SINR
average_throughput = all_throughput/time;
report = average_throughput;