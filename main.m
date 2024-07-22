function main = main(mode,UE_num,time,pptimer,MRN,groupsize,RM,outage,handover)
switch mode
       case 1
          main = simulation(UE_num,time,MRN,RM,'CQI',pptimer,handover,groupsize,outage);
       case 2
          main = simulation(UE_num,time,MRN,RM,'unicast',pptimer,handover,groupsize,outage);
       case 3
          main = simulation(UE_num,time,MRN,RM,'kmeans',pptimer,handover,groupsize,outage);
       case 4
          main = simulation(UE_num,time,MRN,RM,'ours',pptimer,handover,groupsize,outage);
       case 5
          main = simulation(UE_num,time,MRN,RM,'VG',pptimer,handover,groupsize,outage);
       case 6
          main = simulation(UE_num,time,MRN,RM,'broadcast',pptimer,handover,groupsize,outage)
       otherwise
         error('WRONG USE.') 
end
