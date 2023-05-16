%Where are you now?
function now = now_gNB(UE,gNB,noise,handover)
clear sinr
max_sinr = -inf;
old_sinr = -inf;
old = UE.now_gNB;
nowgNB = 0;
state = UE.state;
if state == 1
    target = UE.ppsave;
else
    target = 0;
    target_sinr = -inf;
end
%sinr = SINR(UE,tgNB_num,gNB,noise) 
for i=1:7
    sinr = calculate_SINR(UE,i,gNB,noise);
    if i == old
        old_sinr = sinr;
    end
    if i == target
        target_sinr = sinr;
    end
    if sinr > max_sinr
        max_sinr = sinr;
        nowgNB = i;
    end
end
%Only when the difference of SINR over handover dB, handoff happened.
if state == 0
    if max_sinr < old_sinr+handover
         max_sinr = old_sinr;
         nowgNB = old;
    end
else
    if target_sinr > old_sinr+handover
        max_sinr = target_sinr;
        nowgNB = target;
    end
end
now = [nowgNB max_sinr old_sinr];