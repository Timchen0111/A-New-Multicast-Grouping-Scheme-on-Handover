function main = main(mode,UE_num,time,K,pptimer,handover)
tic
bwmode = 'same';
fixed = 0;
dropnum = floor(UE_num/20);
dropout = 2;
%handover = 10;
%K = floor(UE_num/groupsize);
switch mode
     case 'unicast'
        main = simulation(UE_num,time,dropnum,dropout,K,'unicast',pptimer,handover,bwmode,fixed);
     case 'kmeans'
        disp('K-means');
        main = simulation(UE_num,time,dropnum,dropout,K,'kmeans',pptimer,handover,bwmode,fixed);
     case 'not_reg'
        disp('K-means,HO, not regrouping');
        main = simulation(UE_num,time,dropnum,dropout,K,'not_reg',pptimer,handover,bwmode,fixed);
     case 'random'
        disp('Grouping randomly');
        main = simulation(UE_num,time,dropnum,dropout,K,'random',pptimer,handover,bwmode,fixed);
     case 'GRPPD'
        disp('Grouping randomly and Ping-Pong Detection');
        main = simulation(UE_num,time,dropnum,dropout,K,'GRPPD',pptimer,handover,bwmode,fixed);
     case 'GKPPD'
        disp('Grouping with Ping-Pong Detection and Kmeans.');
        main = simulation(UE_num,time,dropnum,dropout,K,'GKPPD',pptimer,handover,bwmode,fixed);
     case 'GRPPD-UNI'
        disp('Grouping randomly with Ping-Pong Detection. Using unicast for UE in HO.');
        main = simulation(UE_num,time,dropnum,dropout,K,'GRPPD_uni',pptimer,handover,bwmode,fixed);
     case 'GKPPD-UNI'
        disp('Grouping with Ping-Pong Detection and Kmeans. Using unicast for UE in HO.');
        main = simulation(UE_num,time,dropnum,dropout,K,'GKPPD_uni',pptimer,handover,bwmode,fixed);
     case 'dynamic_k'
        disp('Dynamic Kmeans')
        main = simulation(UE_num,time,dropnum,dropout,K,'dynamic_k',pptimer,handover,bwmode,fixed);
     case 'dynamic_k2'
        disp('Dynamic Kmeans(2)')
        main = simulation(UE_num,time,dropnum,dropout,K,'dynamic_k2',pptimer,handover,bwmode,fixed);
     otherwise
        error( 'WRONG USE.' )
end
toc


