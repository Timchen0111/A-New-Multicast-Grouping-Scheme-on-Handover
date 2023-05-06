%Where are you now?
function now = now_gNB(UE,gNB,noise,handover)
clear sinr
max_sinr = -inf;
old_sinr = -inf;
old = UE.now_gNB;
nowgNB = 0;
%sinr = SINR(UE,tgNB_num,gNB,noise) 
for i=1:7
    sinr = SINR(UE,i,gNB,noise);
    if i == old
        old_sinr = sinr;
    end
    if sinr > max_sinr
        max_sinr = sinr;
        nowgNB = i;
    end
end
%Only when the difference of SINR over handover dB, handoff happened.
if max_sinr < old_sinr+handover
     max_sinr = old_sinr;
     nowgNB = old;
end
now = [nowgNB max_sinr old_sinr];


