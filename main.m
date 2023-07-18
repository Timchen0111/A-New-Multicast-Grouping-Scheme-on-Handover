function main = main(mode,UE_num,time,K,pptimer,handover,bwmode)
tic
dropnum = floor(UE_num/10);
dropout = 5;
%handover = 10;
%K = floor(UE_num/groupsize);
switch mode
     case 'unicast'
        main = simulation(UE_num,time,dropnum,dropout,K,'unicast',pptimer,handover,bwmode);
     case 'kmeans'
        disp('K-means');
        main = simulation(UE_num,time,dropnum,dropout,K,'kmeans',pptimer,handover,bwmode);
     case 'random'
        disp('Grouping randomly');
        main = simulation(UE_num,time,dropnum,dropout,K,'random',pptimer,handover,bwmode);
     case 'GRPPD'
        disp('Grouping randomly and Ping-Pong Detection');
        main = simulation(UE_num,time,dropnum,dropout,K,'GRPPD',pptimer,handover,bwmode);
     case 'GKPPD'
        disp('Grouping with Ping-Pong Detection and Kmeans.');
        main = simulation(UE_num,time,dropnum,dropout,K,'GKPPD',pptimer,handover,bwmode);
     case 'GRPPD-UNI'
        disp('Grouping randomly with Ping-Pong Detection. Using unicast for UE in HO.');
        main = simulation(UE_num,time,dropnum,dropout,K,'GRPPD_uni',pptimer,handover,bwmode);
     case 'GKPPD-UNI'
        disp('Grouping with Ping-Pong Detection and Kmeans. Using unicast for UE in HO.');
        main = simulation(UE_num,time,dropnum,dropout,K,'GKPPD_uni',pptimer,handover,bwmode);
     case 'dynamic_k'
        disp('Dynamic Kmeans')
        main = simulation(UE_num,time,dropnum,dropout,K,'dynamic_k',pptimer,handover,bwmode);
     otherwise
        error( 'WRONG USE.' )
end
toc


