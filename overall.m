parfor i = 1:8
    if i <= 4
        a6(i,:) = main('GRPPD-UNI',50,3000,10,64);
        a7(i,:) = main('GKPPD-UNI',50,3000,10,64);
    elseif i >8
        a1(i-8,:) = main('random',50,3000,10,64);
        a2(i-8,:) = main('random',50,3000,10,64);
        a3(i-8,:) = main('kmeans',50,3000,10,64);
    else
        a4(i-4,:) = main('GRPPD',50,3000,10,64);
        a5(i-4,:) = main('GKPPD',50,3000,10,64);
    end
end
    
% end
a3 = transpose(a3);
a4 = transpose(a4);
a5 = transpose(a5);
a6 = transpose(a6);


