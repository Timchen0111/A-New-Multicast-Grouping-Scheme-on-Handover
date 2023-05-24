clear all
parfor i = 1:60
    if i <= 20
        %a1(i,:) = main('unicast',50,3000,10,32,10);
        a2(i,:) = main('random',50,3000,1,10,10);
        a3(i,:) = main('kmeans',50,3000,1,10,10);
    elseif i > 40 
        a4(i-40,:) = main('GRPPD',50,3000,5,1,10);
        a5(i-40,:) = main('GKPPD',50,3000,5,1,10);        
    else 
        a6(i-20,:) = main('GRPPD-UNI',50,3000,5,1,10);
        a7(i-20,:) = main('GKPPD-UNI',50,3000,5,1,10);
    end
end
% end
R = [a2 a3 a4 a5 a6 a7]';


