function report = simulation(UE_num,time,dropnum,dropout,K,mode,pptimer,handover)
%Scheme: Add Ping-Pong Detection on grouping
the_devil = 'not here';
if mode == "GRPPD" 
    GRPPD = true;
else
    if mode == "GKPPD"
        GRPPD = true;
    else
        GRPPD = false;
    end
end
%pingpongarray = zeros(UE_num,1)
bw = 1e8;
Regroup_count = 0;
total_eff = 0;
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
if GRPPD ==false
    groupnum = K
else
    groupnum = K+1
end
for i=1:19
    gNB(i).pos = [inf,inf];
    gNB(i).worstSINR = inf;
end

gNB = set_gNB(gNB,UE_num,K);

bw = 1e8;
noise = -174+10*log10(bw); %db

for i=1:UE_num
    X = [inf,inf];
    while boundary(X(1),X(2)) == false
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
    %UE(i).ppDrop = false;
    gNB(UE(i).now_gNB) = add_remove(gNB(UE(i).now_gNB),UE(i),1);
end

%Set velocity
for i=1:UE_num
    UE(i).velocity = velocity(UE(i).pos);
end

change = 0;

for i=1:UE_num
    pos = UE(i).pos;
    x(i) = pos(1);
    y(i) = pos(2);
end
for i=1:7
    x(end+1) = gNB(i).pos(1);
    y(end+1) = gNB(i).pos(2);
end
figure(1)
c = gNB_color(UE); 
scatter(x,y,[],c)
clear x y

%Loop
for i = 1:7
     gNB(i)
end
for t=1:time %600 %1 minutes
    %Initial
    %disp(t)
    disp(UE(1).pptimer)
    %disp(UE(1).pos)
    T = 10*t;
    if rem(t,100)==0
        disp(['time:' string(T) 'ms'])
    end
    %disp(['time:' string(T) 'ms'])
    %Only change grouping on t%10 = 0
    if t == 1
        for i = 1:7 
            gNB(i) = regrouping(gNB(i),K,UE,mode);
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
        if boundary(UE(i).pos(1),UE(i).pos(2)) == false
            v = UE(i).velocity;
            UE(i).velocity = velocity(UE(i).pos,v);
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
%             if GRPPD == true
%                 UE(i).ppDrop = true;
%             end
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

    
    %Update worst SINR
    if skip == true
        continue
    end
%     for i = 1:UE_num
%         %UE(i).SINR = SINR(UE(i),UE(i).now_gNB,gNB,noise);
%         UE(i).SINR = now_(2);
%     end
    
    for index = 1:7
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
            %std(sinr);
            for j = 1:numel(ingroup)
                if abs(sinr(j)-mean(sinr)) > dropout && ppDrop(j) == -1
                    drop_out(end+1) = ingroup(j); %Record UEs be dropped out
                end
                if ppDrop(j) > -1 && GRPPD == true
                    scgroup(end+1) = ingroup(j);
                end
            end
            for i = 1:length(scgroup)
                if UE(scgroup(i)).pptimer == -1
                    the_devil = 'Catch you!Devil';
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
            clear sinr drop_out ppDrop
        end
    end

    for i = 1:7
        if drop_num(i) > dropnum            
            regroup(i) = true;
        else
            regroup(i) = false;
        end
    end

    %To SC group stage
%         disp(t)
%         for i = 1:7
%             gNB(i)
%         end

    %disp('--------to SC group stage-------')
        if GRPPD == true
            for i = 1:7
                gNB(i).joinUE = [gNB(i).joinUE gNB(i).scUE];
                scnum = numel(gNB(i).scUE);
                gNB(i).scUE = [];
                sc(1:scnum) = K+1; 
                gNB(i).group = [gNB(i).group sc];
                sc = [];
            end
        end
    %add UE stage

    %disp('--------AddUE Stage-------')
        %Update worst SINR
        for index = 1:7
            if regroup(index) == false
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
        %Add UE
        approach = 1;

        %Approach 1:ADD THE CLOSEST GROUP BUT NOT CUMBRACE OTHER UE
            if regroup(index) == false && approach==1
                for i = 1:numel(gNB(index).waitingUE)
                    UE_be_added = gNB(index).waitingUE(i);
                    if GRPPD == true
                        sinr(1:K+1) = UE(UE_be_added).SINR;
                    else
                        sinr(1:K) = UE(UE_be_added).SINR;
                    end
                    diff = sinr-gNB(index).worstSINR;
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
            end
           
        end

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
                KK = min(K,length(gNB(i).joinUE));
                if KK > 0
                    gNB(i) = regrouping(gNB(i),K,UE,mode);
                end
            end
        end
        %Update worst SINR
        for index = 1:7
            for group_now = 1:groupnum %K+1
                ingroup = gNB(index).joinUE(find(gNB(index).group == group_now)); %BUGBUGBUG
                worst = inf;
                for i = 1:numel(ingroup)
                    if UE(ingroup(i)).SINR<worst
                        worst = UE(ingroup(i)).SINR;
                    end
                end
                gNB(index).worstSINR(group_now) = worst;
            end
        end
        %Checking
        sumue = 0;
        for i = 1:7
            sumue = numel(gNB(i).joinUE)+sumue+numel(gNB(i).waitingUE)+numel(gNB(i).scUE);
        end
        if sumue ~= UE_num
            for i = 1:7
                gNB(i)
            end
            disp(t)
            error('WRONG UE NUM')
        end
%Update worst SINR
    for index = 1:7
        for group_now = 1:groupnum
            if numel(gNB(index).joinUE) == 0
                gNB(index).worstSINR(group_now) = inf;
                continue
            end
            ingroup = gNB(index).joinUE(find(gNB(index).group == group_now));
            worst = inf;
            for i = 1:numel(ingroup)
                if UE(ingroup(i)).SINR<worst
                    worst = UE(ingroup(i)).SINR;
                end
            end
            gNB(index).worstSINR(group_now) = worst;
        end
        %Calculate Efficiency
        efficiency = 0;
        for i = 1
            member_num = zeros(1,K);
            for j = 1:K
                  member_num(j) = nnz(gNB(i).group==j);
            end
            if GRPPD == true
                member_num(K+1) = nnz(gNB(i).group==K+1);
            end
            worstSINR2 = gNB(i).worstSINR;
            worstSINR2((worstSINR2==inf)) = [];
            member_num(member_num==0) = [];
            R = rate(10.^(worstSINR2./10),bw);
            throughput = sum(member_num.*R);          
            if numel(worstSINR2)>0
                resource = sum(1./R);
                efficiency = efficiency+throughput/resource;
            end
        end        
    end
    total_eff = total_eff+efficiency;
    %disp('end a time')
    for i = 1:UE_num
        for j = 1:length(gNB(UE(i).now_gNB))
            if gNB(UE(i).now_gNB).joinUE(j) == i
                index = j;
            end
        end
        if gNB(UE(i).now_gNB).group(j) == K+1
            if UE(i).pptimer == -1
                gNB(UE(i).now_gNB)
                i
                UE(i).pptimer
                the_devil
                error('FUCK.SHIT.BITCH.GO TO HELL.')
            end
        end
    end
end
disp('----------------------REPORT----------------------')
sc_rate = sctime./(sctime+staytime);
% sc_ratio = mean(sc_rate)
fail_rate = fail./(success+fail);
% all_fail_rate = sum(fail)./(sum(success)+sum(fail))
plotgraph(sc_rate,fail_rate)
% pingpong_rate = all_fail_rate.*sc_ratio
% disp('stay_sinr')
% disp(stay_sinr)
% disp('sc_sinr')
% disp(sc_sinr)
for i = 1:7
     gNB(i)
end

for i=1:UE_num
    pos = UE(i).pos;
    x(i) = pos(1);
    y(i) = pos(2);
    UE(i).pptimer
end
for i=1:7
    x(end+1) = gNB(i).pos(1);
    y(end+1) = gNB(i).pos(2);
end
figure(2)
c = gNB_color(UE); 
scatter(x,y,[],c)

%UE.SINR
average_efficiency = 10*total_eff/time;
average_efficiency
Regroup_count
change
report = average_efficiency;
%pingpongarray(1)
