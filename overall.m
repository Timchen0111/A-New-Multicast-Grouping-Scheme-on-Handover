clear all
parfor i = 1:12
    if i <= 2
        %a1(i,:) = main('unicast',50,3,10,32,10);
        a2(i,:) = main('random',50,6000,5,10,10);
        a3(i,:) = main('kmeans',50,6000,5,10,10);
    elseif i > 8
        a4(i-8,:) = main('GRPPD',50,6000,5,1,10);
        a5(i-8,:) = main('GKPPD',50,6000,5,1,10);        
    else 
        a6(i-4,:) = main('GRPPD-UNI',50,6000,5,1,10);
        a7(i-4,:) = main('GKPPD-UNI',50,6000,5,1,10);
    end
end
% end
R = [a2 a3 a4 a5 a6 a7]';


