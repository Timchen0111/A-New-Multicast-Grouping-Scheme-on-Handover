function report = unicast(UE_num,time,dropnum,dropout,K,mode,pptimer)
%pingpongarray = zeros(UE_num,1)
bw = 1e8;
Regroup_count = 0;
total_eff = 0;
pingpong_time = pptimer;%input('timer: ');
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

gNB.num = 0;
gNB.pos = [inf,inf];
gNB.joinUE = [];
gNB.waitingUE = [];
gNB.scUE = [];
gNB.group = []; 
gNB.groupnum = K;
gNB.worstSINR = zeros(K);

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
        X = 400*rand(2,1)-200;
    end
    UE(i).num = i;
    UE(i).pos = X;%generate random initial position of UEs
    UE(i).now_gNB = now_gNB(UE(i),gNB,noise);
    UE(i).SINR = SINR(UE(i),UE(i).now_gNB,gNB,noise);
    UE(i).change_admission = false;
    UE(i).pptimer = -1;
    UE(i).ppsave = [];
    UE(i).ppDrop = false;
    gNB(UE(i).now_gNB) = add_remove(gNB(UE(i).now_gNB),UE(i),1);
end

for i=1:UE_num
    pos = UE(i).pos;
    x(i) = pos(1);
    y(i) = pos(2);
end

%figure(1)

%c = gNB_color(UE);

%scatter(x,y,[],c)
%Set velocity

for i=1:UE_num
    UE(i).velocity = velocity(UE(i).pos);
end

%Loop

for t=1:time %600 %1 minutes
    %Initial
    T = 10*t;
    if rem(t,100)==0
        disp(['time:' string(T) 'ms'])
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
        old = UE(i).now_gNB;
        now = now_gNB(UE(i),gNB,noise);

        if UE(i).pptimer>-1 && UE(i).pptimer<pingpong_time
            UE(i).pptimer = UE(i).pptimer+1;
            %disp('--------------Handover Preparation--------------')
        end

        if old ~= now && UE(i).pptimer == -1
            UE(i).pptimer = 0; %Start SC event
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
            UE(i).now_gNB = now;
            gNB(old) = add_remove(gNB(old),UE(i),2);
            if numel(find(gNB(old).waitingUE == i))>0
                rem_waiting = find(gNB(old).waitingUE == i);               
                gNB(old).waitingUE(rem_waiting) = []; 
            end
            gNB(UE(i).now_gNB) = add_remove(gNB(UE(i).now_gNB),UE(i),1);
        end
        
    end

    if skip == true
        continue
    end

    for i = 1:7
        disp(gNB(i))
        for j = 1:numel(gNB(i).joinUE)
            ue = gNB(i).joinUE(j);
            gNB(i) = add_remove(gNB(i),UE(ue),2);
            gNB(i) = add_remove(gNB(i),UE(ue),1);
        end
        gNB(i) = regrouping(gNB(i),K,UE,mode);
    end

    for i = 1:UE_num
        UE(i).SINR = SINR(UE(i),UE(i).now_gNB,gNB,noise);
    end
    
    for index = 1:7
        for i = 1:numel(gNB(index).joinUE)
            if numel(gNB(index).joinUE)>0
                gNB(index).worstSINR(i) = UE(gNB(index).joinUE(i)).SINR;
            else
                gNB(index).worstSINR(i) = 0;
            end
        end
    end

        %Calculate Efficiency
        efficiency = 0;
        for i = 1:7
            member_num = zeros(1,gNB(i).groupnum);
            for j = 1:gNB(i).groupnum
                 member_num(j) = nnz(gNB(i).group==j);
            end
            worstSINR2 = gNB(i).worstSINR;
            gNB(i).worstSINR(find(gNB(i).worstSINR==inf)) = 0;
            gNB(i).worstSINR;
            R = rate(10.^(gNB(i).worstSINR./10),bw);
            throughput = sum(member_num.*R); 
            worstSINR2((worstSINR2==inf)) = [];
            
            if numel(worstSINR2)>0
                R2 = rate(10.^(worstSINR2./10),bw);
                resource = sum(1./R2);
                efficiency = efficiency+sum(throughput/resource)*(numel(gNB(i).joinUE)/UE_num);
            end
        end       
    total_eff = total_eff+efficiency;
    for i = 1:7
        gNB(i)
    end
end
disp('----------------------REPORT----------------------')
% sc_rate = sctime./(sctime+staytime);
% sc_ratio = mean(sc_rate)
% fail_rate = fail./(success+fail);
% all_fail_rate = sum(fail)./(sum(success)+sum(fail))
% plotgraph(sc_rate,fail_rate)
% pingpong_rate = all_fail_rate.*sc_ratio
% disp('stay_sinr')
% disp(stay_sinr)
% disp('sc_sinr')
% disp(sc_sinr)
for i = 1:7
    gNB(i);
end

%UE.SINR
average_efficiency = 10*total_eff/time;
average_efficiency
Regroup_count
report = [average_efficiency Regroup_count];
%pingpongarray(1)
