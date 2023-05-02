function main = main(mode,UE_num,time,groupsize,pptimer)
tic
dropnum = floor(UE_num/10);
dropout = 10;
K = floor(UE_num/groupsize);
switch mode
     case 'unicast'
        main = unicast(UE_num,time,K,'unicast',pptimer);
     case 'broadcast'
     case 'kmeans'
        disp('K-means');
        main = simulation(UE_num,time,dropnum,dropout,K,'kmeans',pptimer);
     case 'random'
        disp('Grouping randomly');
        main = simulation(UE_num,time,dropnum,dropout,K,'random',pptimer);
     case 'GRPPD'
        disp('Grouping randomly and Ping-Pong Detection');
        main = simulation(UE_num,time,dropnum,dropout,K,'GRPPD',pptimer);
     case 'GKPPD'
        disp('Grouping with Ping-Pong Detection and Kmeans.');
        main = simulation(UE_num,time,dropnum,dropout,K,'GKPPD',pptimer);
     case 'GRPPD-UNI'
        disp('Grouping randomly with Ping-Pong Detection. Using unicast for UE in HO.');
        main = simulation_uni(UE_num,time,dropnum,dropout,K,'GRPPD',pptimer);
     case 'GKPPD-UNI'
        disp('Grouping with Ping-Pong Detection and Kmeans. Using unicast for UE in HO.');
        main = simulation_uni(UE_num,time,dropnum,dropout,K,'GKPPD',pptimer);
     otherwise
        error( 'WRONG USE.' )
end
toc
