function main = main(mode,UE_num,time,groupsize,pptimer)
tic
dropnum = floor(UE_num/10);
dropout = 5;
handover = 3;
K = floor(UE_num/groupsize);
switch mode
     case 'unicast'
        main = unicast(UE_num,time,K,'unicast',pptimer,handover);
     case 'broadcast'
     case 'kmeans'
        disp('K-means');
        main = simulation(UE_num,time,dropnum,dropout,K,'kmeans',pptimer,handover);
     case 'random'
        disp('Grouping randomly');
        main = simulation(UE_num,time,dropnum,dropout,K,'random',pptimer,handover);
     case 'GRPPD'
        disp('Grouping randomly and Ping-Pong Detection');
        main = simulation(UE_num,time,dropnum,dropout,K,'GRPPD',pptimer,handover);
     case 'GKPPD'
        disp('Grouping with Ping-Pong Detection and Kmeans.');
        main = simulation(UE_num,time,dropnum,dropout,K,'GKPPD',pptimer,handover);
     case 'GRPPD-UNI'
        disp('Grouping randomly with Ping-Pong Detection. Using unicast for UE in HO.');
        main = simulation_uni(UE_num,time,dropnum,dropout,K,'GRPPD',pptimer,handover);
     case 'GKPPD-UNI'
        disp('Grouping with Ping-Pong Detection and Kmeans. Using unicast for UE in HO.');
        main = simulation_uni(UE_num,time,dropnum,dropout,K,'GKPPD',pptimer,handover);
     otherwise
        error( 'WRONG USE.' )
end
toc
