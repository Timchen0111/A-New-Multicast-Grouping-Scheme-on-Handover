function sf = shadow_fading(sf_old,sigma,num)
%num
md = 1; %最小單位: 1meter
if sf_old == 0   
    sf = zeros(num);
    %generate random fading(normal RV)
    rf = sigma.*randn(num,num);
    %generate R matrix
    R = [1 cf(md) cf(2*md) cf(md) cf(sqrt(2)*md);cf(md) 1 cf(md) cf(sqrt(2)*md) cf(md);cf(2*md) cf(md) 1 cf(sqrt(5)*md) cf(sqrt(2)*md);cf(md) cf(sqrt(2)*md) cf(sqrt(5)*md) 1 cf(md);cf(sqrt(2)*md) cf(md) cf(sqrt(2)*md) cf(md) 1];
    L = chol(R)';
    R_ = R;
    R_(end,:) = [];
    R_(:,end) = [];
    L_ = chol(R_)';
    
    %R1:i==1
    R1 = R;
    R1(1:3,:) = [];
    R1(:,1:3) = [];
    L1 = chol(R1)';
    R1(end,:) = [];
    R1(:,end) = [];
    L1_ = chol(R1)';
    %R2:j==1
    R2 = R;
    R2(4,:) = [];
    R2(1,:) = [];
    R2(:,4) = [];
    R2(:,1) = [];
    L2 = chol(R2)';
    R2(end,:) = [];
    R2(:,end) = [];
    L2_ = chol(R2)';
    %R3:J = end
    R3 = R;
    R3(3,:) = [];
    R3(:,3) = [];
    L3 = chol(R3);
    R3(end,:) = [];
    R3(:,end) = [];
    L3_ = chol(R3)';
    
    for i = 1:num
        for j = 1:num
            a = rf(i,j);
            if i == 1
                %No upper           
                if j == 1
                    sf(i,j) = a;
                else
                    s_ = inv(L1_)*[sf(i,j-1)]';
                    sf(i,j) = L1(end,:)*[s_',a]';
                end
            else
                if j == 1
                    %No left          
                    s_ = inv(L2_)*[sf(i-1,j) sf(i,j+1)]';
                    sf(i,j) = L2(end,:)*([s_',a]');
                elseif j == num
                    %No right
                    s_ = inv(L3_)*[sf(i-1,j-1) sf(i-1,j) sf(i,j-1)]';
                    sf(i,j) = L3(end,:)*([s_',a]');
                else
                    %R
                    s_ = inv(L_)*[sf(i-1,j-1) sf(i-1,j) sf(i-1,j+1) sf(i,j-1)]';
                    sf(i,j) = L(end,:)*([s_',a]');
                end
            end
        end
    end
    return
end

md = 1;
%最小單位: 1meter
sf = zeros(num);
%generate random fading(normal RV)
rf = sigma.*randn(num,num);
%generate R matrix
%加入時間維度：視為一立體空間，時間為第三維，一時間單位距離暫定為一格空間距離
R = [1 cf(sqrt(3)*md) cf(sqrt(2)*md) cf(sqrt(3)*md) cf(sqrt(2)*md) cf(md);cf(sqrt(3)*md) 1 cf(md) cf(2*md) cf(md) cf(sqrt(2)*md);cf(sqrt(2)*md) cf(md) 1 cf(md) cf(sqrt(2)*md) cf(md);cf(sqrt(3)*md) cf(2*md) cf(md) 1 cf(sqrt(5)*md) cf(sqrt(2)*md);cf(sqrt(2)*md) cf(md) cf(sqrt(2)*md) cf(sqrt(5)*md) 1 cf(md);cf(md) cf(sqrt(2)*md) cf(md) cf(sqrt(2)*md) cf(md) 1];
L = chol(R)';

R0 = R;
R0(2:5,:) = [];
R0(:,2:5) = [];
L0 = chol(R0)';
R0(end,:) = [];
R0(:,end) = [];
L0_ = chol(R0)';

R_ = R;
R_(end,:) = [];
R_(:,end) = [];
L_ = chol(R_)';

%R1:i==1
R1 = R;
R1(2:4,:) = [];
R1(:,2:4) = [];
L1 = chol(R1)';
R1(end,:) = [];
R1(:,end) = [];
L1_ = chol(R1)';

%R2:j==1
R2 = R;
R2(5,:) = [];
R2(2,:) = [];
R2(:,5) = [];
R2(:,2) = [];
L2 = chol(R2)';
R2(end,:) = [];
R2(:,end) = [];
L2_ = chol(R2)';
%R3:J = end
R3 = R;
R3(4,:) = [];
R3(:,4) = [];
L3 = chol(R3);
R3(end,:) = [];
R3(:,end) = [];
L3_ = chol(R3)';

for i = 1:num
    for j = 1:num
        a = rf(i,j);
        if i == 1
            %No upper           
            if j == 1
                s_ = inv(L0_)*[sf_old(i,j)]';
                sf(i,j) = L0(end,:)*[s_',a]';
            else
                s_ = inv(L1_)*[sf_old(i,j) sf(i,j-1)]';
                sf(i,j) = L1(end,:)*[s_',a]';
            end
        else
            if j == 1
                %No left          
                s_ = inv(L2_)*[sf_old(i,j) sf(i-1,j) sf(i,j+1)]';
                sf(i,j) = L2(end,:)*([s_',a]');
            elseif j == num
                %No right
                s_ = inv(L3_)*[sf_old(i,j) sf(i-1,j-1) sf(i-1,j) sf(i,j-1)]';
                sf(i,j) = L3(end,:)*([s_',a]');
            else
                %R
                s_ = inv(L_)*[sf_old(i,j) sf(i-1,j-1) sf(i-1,j) sf(i-1,j+1) sf(i,j-1)]';
                sf(i,j) = L(end,:)*([s_',a]');
            end
        end
    end
end

