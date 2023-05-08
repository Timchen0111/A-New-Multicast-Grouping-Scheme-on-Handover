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
clear all
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


