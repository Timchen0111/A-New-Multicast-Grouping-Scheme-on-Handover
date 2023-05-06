function report = unicast(UE_num,time,K,mode,pptimer,handover)
%pingpongarray = zeros(UE_num,1)
handover_num = 0;
bw = 1e8;
Regroup_count = 0;
total_eff = 0;
pingpong_time = pptimer;%input('timer: ');
%staytime = zeros(1,UE_num);
%sctime = zeros(1,UE_num);
success = zeros(1,UE_num);
fail = zeros(1,UE_num);
%stay_sinr = 0;
%sc_sinr = 0;

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
    UE(i).ppDrop = false;
    UE(i).state = 0;
    gNB(UE(i).now_gNB) = add_remove(gNB(UE(i).now_gNB),UE(i),1);
end
%Set velocity

for i=1:UE_num
    UE(i).velocity = velocity(UE(i).pos);
end

%Loop

for t=1:time %6000 %10 minutes
    %Initial
    disp(UE(1).pptimer)
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
%             if UE(i).pptimer == -1
%                  %disp('--------------Stay in gNB--------------')
%                  staytime(1,i) = staytime(1,i)+1;
%                  stay_sinr = ((sum(staytime)-1)*stay_sinr+UE(i).SINR)/sum(staytime);
%              else
%                  sctime(1,i) = sctime(1,i)+1;
%                  sc_sinr = ((sum(sctime)-1)*sc_sinr+UE(i).SINR)/sum(sctime);                
%              end
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
            handover_num = handover_num+1;
            UE(i).now_gNB = now;
            UE(i).state = 0;
            UE(i).SINR = Now(2);
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
        for j = 1:numel(gNB(i).joinUE)
            ue = gNB(i).joinUE(1);
            gNB(i) = add_remove(gNB(i),UE(ue),2);
            gNB(i) = add_remove(gNB(i),UE(ue),1);
        end
        gNB(i) = regrouping(gNB(i),K,UE,mode);
        gNB(i).groupnum = max(K,numel(gNB(i).joinUE));
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
            %gNB(i).groupnum = length(gNB(i).joinUE);
            worstSINR2 = gNB(1).worstSINR;
            worstSINR2((worstSINR2==inf)) = [];
            if ~isempty(worstSINR2)
                R = rate(10.^(worstSINR2./10),bw);
                throughput = sum(R); 
                resource = sum(1./R);
                efficiency = throughput/resource;
            else
                efficiency = 0;
            end
    total_eff = total_eff+efficiency;
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
    gNB(i)
end

for i=1:UE_num
    pos = UE(i).pos;
    x(i) = pos(1);
    y(i) = pos(2);
end
x
y
for i=1:7
    x(end+1) = gNB(i).pos(1);
    y(end+1) = gNB(i).pos(2);
end
figure(1)
c = gNB_color(UE); 
scatter(x,y,[],c)


%UE.SINR
average_efficiency = 10*total_eff/time;
average_efficiency
Regroup_count
handover_num
report = [average_efficiency Regroup_count];
%pingpongarray(1)
