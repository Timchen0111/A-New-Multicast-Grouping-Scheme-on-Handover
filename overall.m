% parfor i = 1:4
%     r(i,:) = main('random',100,600,5,20);
%     k(i,:) = main('kmeans',100,600,5,20);
%     gr(i,:) = main('GRPPD',100,600,5,20);
%     gk(i,:) = main('GKPPD',100,600,5,20);
%     gru(i,:) = main('GRPPD-UNI',100,600,5,20);
%     gku(i,:) = main('GKPPD-UNI',100,600,5,20);
% end
% all = [uni r k gr gk gru gku];
% writetable(all, 'result.csv');
parfor i = 1:4
    %a1(i,:) = main('unicast',50,3000,10,20);
    %a2(i,:) = main('random',50,3000,10,20);
    %a3(i,:) = main('kmeans',50,3000,10,20);
    main('GRPPD',50,3000,10,20);
    %a5(i,:) = main('GKPPD',50,3000,10,20);
    %a6(i,:) = main('GRPPD-UNI',50,3000,10,20);
    %a7(i,:) = main('GKPPD-UNI',50,3000,10,20);
end


