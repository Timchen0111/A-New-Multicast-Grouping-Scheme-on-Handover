clear all
tic
t = 60;
parfor i = 1:12
    if i <= 4
        a1(i,:) = main('unicast',50,t,10,10,10);
        a2(i,:) = main('random',50,t,5,10,10);
        a3(i,:) = main('kmeans',50,t,5,10,10);
    elseif i > 8
        disp(i)
        a4(i-8,:) = main('GRPPD',50,t,5,10,10);
        a5(i-8,:) = main('GKPPD',50,t,5,10,10);        
    else 
        a6(i-4,:) = main('GRPPD-UNI',50,t,5,10,10);
        a7(i-4,:) = main('GKPPD-UNI',50,t,5,10,10);
    end
end
% end
R = [a1 a2 a3 a4 a5 a6 a7]';
toc

