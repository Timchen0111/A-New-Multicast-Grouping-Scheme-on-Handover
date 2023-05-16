parfor i = 1:8
    if i <= 4
        a3(i,:) = main('GKPPD',50,3000,10,10);
        a4(i,:) = main('GRPPD-UNI',50,3000,10,10);
    else
        a5(i,:) = main('GKPPD-UNI',50,3000,10,10);
        a6(i,:) = main('random',50,3000,5,10);
    end
end
    
% end
a3 = transpose(a3);
a4 = transpose(a4);
a5 = transpose(a5);
a6 = transpose(a6);


