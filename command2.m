clear all
r = zeros(1,5);
r2 = zeros(1,5);
r3 = zeros(1,5);
r4 = zeros(1,5);
r5 = zeros(1,5);
r6 = zeros(1,5);
t =3000;
UE =100;
TTT =1.28;
HM=9;
for i = 1:5
     %a2 = main(6,UE,t,100,TTT,HM,0);%groupsize = 0 when broadcast,uni
     %a1 = main(7,UE,t,1,TTT,HM,0);    
     a3 = main(8,50,t,100,TTT,HM,2);
     a4 = main(8,100,t,100,TTT,HM,2);
     a5 = main(8,150,t,100,TTT,HM,2);
     a6 = main(8,200,t,100,TTT,HM,2);
     %r(i) = a1;
     %r2(i) = a2;
     r3(i) = a3;
     r4(i) = a4;
     r5(i) = a5;
     r6(i) = a6;
end
result = [mean(r3) mean(r4) mean(r5) mean(r6)]';

% TTT = 1.28;
% for i = 1:5
%      a2 = main(6,UE,t,100,TTT,HM,0);%groupsize = 0 when broadcast,uni
%      a1 = main(7,UE,t,1,TTT,HM,0);    
%      a3 = main(8,UE,t,100,TTT,HM,1.5);
%      a4 = main(8,UE,t,100,TTT,HM,2);
%      a5 = main(8,UE,t,100,TTT,HM,2.5);
%      a6 = main(8,UE,t,100,TTT,HM,3);
%      r(i) = a1;
%      r2(i) = a2;
%      r3(i) = a3;
%      r4(i) = a4;
%      r5(i) = a5;
%      r6(i) = a6;
% end
% result2 = [mean(r) mean(r2) mean(r3) mean(r4) mean(r5) mean(r6)]';
