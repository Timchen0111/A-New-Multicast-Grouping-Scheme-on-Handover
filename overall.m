clear all
tic
t = 3000;
ttt = 2.56;
HO = 9;
a1 = zeros(1,5);
a2 = zeros(1,10);
a3 = zeros(1,15);
a4 = zeros(1,15);
a3 = zeros(1,20);
a4 = zeros(1,20);
parfor i = 1:20
    if i <= 5
        a1(1,i) = main('unicast',100,t,100,ttt,HO,3);
    elseif i <= 10      
        a2(1,i) = main('kmeans',100,t,1,ttt,HO,0);
    elseif i <= 15
        a3(1,i) = main('GKPPD',100,t,100,ttt,HO,1.5);
        a4(1,i) = main('GKPPD',100,t,100,ttt,HO,2);
    else
        a5(1,i) = main('GKPPD',100,t,100,ttt,HO,2.5);
        a6(1,i) = main('GKPPD',100,t,100,ttt,HO,3);
    end
end
a2 = a2(6:10);
a3 = a3(11:15);
a4 = a4(11:15);
a5 = a5(16:20);
a6 = a6(16:20);
toc
result = [mean(a2) mean(a1) mean(a3) mean(a4) mean(a5) mean(a6)]';