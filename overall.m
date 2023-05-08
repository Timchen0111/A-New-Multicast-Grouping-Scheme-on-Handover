parfor i = 1:12
    if i <=4
        a1(i,:) = main('unicast',50,3000,5,10);
    elseif i>8
        a2(i-8,:) = main('GRPPD-UNI',50,3000,15,10);
    else
        a3(i-4,:) = main('GKPPD-UNI',50,3000,15,10);
    end
    %a1(i,:) = main('GKPPD',50,3000,10,5);
    %a2(i,:) = main('GKPPD',50,3000,10,10);
    %a6(i,:) = main('GRPPD-UNI',50,3000,10,20);
end


