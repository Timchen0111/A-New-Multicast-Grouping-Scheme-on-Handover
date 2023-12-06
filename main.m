function main = main(mode,UE_num,time,K,pptimer,handover,groupsize)
tic
dropnum = floor(UE_num/20);
dropout = 2;

 switch mode
       case 1
          main = simulation_nf(UE_num,time,dropnum,dropout,K,'unicast',pptimer,handover,'same',s);
       case 2
          main = simulation_nf(UE_num,time,dropnum,dropout,K,'kmeans',pptimer,handover,'same',s);
       case 3
          main = simulation_nf(UE_num,time,dropnum,dropout,K,'GKPPD',pptimer,handover,'same',s);
       case 4
         main = simulation_nf(UE_num,time,dropnum,dropout,K,'dynamic_k2',pptimer,handover,'same',s);
       case 5
         main = simulation_nf(UE_num,time,dropnum,dropout,K,'new_k',pptimer,handover,'same',s);
       case 6
          main = simulation(UE_num,time,dropnum,dropout,K,'unicast',pptimer,handover,'same',groupsize);
       case 7
          main = simulation(UE_num,time,dropnum,dropout,K,'kmeans',pptimer,handover,'same',groupsize);
       case 8
          main = simulation(UE_num,time,dropnum,dropout,K,'GKPPD',pptimer,handover,'same',groupsize);
       case 9
          main = simulation(UE_num,time,dropnum,dropout,K,'dynamic_k',pptimer,handover,'same',groupsize);
       case 10
          main = simulation(UE_num,time,dropnum,dropout,K,'dynamic_k2',pptimer,handover,'same',groupsize);
       otherwise
         error( 'WRONG USE.' ) 
end
% %s.delete();
toc 
