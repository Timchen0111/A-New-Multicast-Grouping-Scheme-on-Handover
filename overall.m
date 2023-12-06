clear all
tic
t = 3;
parfor i = 17:20
    if i <= 4
        a1(i,:) = main('unicast',100,t,1,32,10,'fair');
        a2(i,:) = main('unicast',100,t,1,32,10,'same');
    elseif i <= 8
        a3(i-4,:) = main('kmeans',100,t,1,32,10,'fair');
        a4(i-4,:) = main('kmeans',100,t,1,32,10,'same');        
    elseif i <= 12
        a5(i-8,:) = main('GKPPD',100,t,1,32,10,'fair');
        a6(i-8,:) = main('GKPPD',100,t,1,32,10,'same');
    elseif i<=16
        a7(i-12,:) = main('GKPPD',100,t,5,32,10,'fair');
        a8(i-12,:) = main('GKPPD',100,t,5,32,10,'same');
    else
        a9(i-16,:) = main('dynamic_k',100,t,5,32,10,'fair');
        a10(i-16,:) = main('dynamic_k',100,t,5,32,10,'same');
    end
end
toc