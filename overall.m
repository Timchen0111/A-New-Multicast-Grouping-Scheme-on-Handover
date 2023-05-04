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
    main('unicast',50,3000,10,20);
end


