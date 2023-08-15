function sf = shadow_fading(sigma,num)
%num
md = 1;
%最小單位: 1meter
sf = zeros(num);
%generate random fading(normal RV)
rf = sigma.*randn(num,num);
%generate R matrix
R = [1 cf(md) cf(2*md) cf(md) cf(sqrt(2)*md); cf(md) 1 cf(md) cf(sqrt(2)*md) cf(md); cf(2*md) cf(md) 1 cf(sqrt(5)*md) cf(sqrt(2)*md); cf(md) cf(sqrt(2)*md) cf(sqrt(5)*md) 1 cf(md); cf(sqrt(2)*md) cf(md) cf(sqrt(2)*md) cf(md) 1];
L = chol(R)';
%R1:i==1
R1 = R(4:5,4:5);
L1 = chol(R1)';
%R2:j==1
R2 = R;
R2(1,:) = [];
R2(4,:) = [];
R2(:,1) = [];
R2(:,4) = [];
L2 = chol(R2);
%R3:J = end
R3 = R;
R3(3,:) = [];
R3(:,3) = [];
L3 = chol(R3);


for i = 1:num
    for j = 1:num
        a = rf(i,j);
        if i == 1
            %No upper           
            if j == 1
                sf(i,j) = a;
            else
                s_ = inv(L1)*[sf(i,j-1)];
                sf(i,j) = L1(end,:)*[s_,a]';
            end
        else
            if j == 1
                %No left
                s_ = inv(L2)*[sf(i-1,j+1) sf(i,j-1)];
                sf(i,j) = L2(end,:)*([s_,a]');
            elseif j == num
                %No right
                s_ = inv(L3)*[sf(i-1,j-1) sf(i-1,j) sf(i,j-1)];
                sf(i,j) = L3(end,:)*([s_,a]');
            else
                %R
                s_ = inv(L)*[sf(i-1,j-1) sf(i-1,j) sf(i-1,j+1) sf(i,j-1)];
                sf(i,j) = L(end,:)*([s_,a]');
            end
        end
    end
end

