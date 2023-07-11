clear all
parfor i = 1:6
    if i <= 2
        a1(i,:) = main('unicast',50,3000,10,32,10);
        a2(i,:) = main('random',50,3,1,10,10);
        a3(i,:) = main('kmeans',50,3,1,10,10);
    elseif i > 4 
        a4(i-4,:) = main('GRPPD',50,3,5,1,10);
        a5(i-4,:) = main('GKPPD',50,3,5,1,10);        
    else 
        a6(i-2,:) = main('GRPPD-UNI',50,3,5,1,10);
        a7(i-2,:) = main('GKPPD-UNI',50,3,5,1,10);
    end
end
% end
R = [a2 a3 a4 a5 a6 a7]';


