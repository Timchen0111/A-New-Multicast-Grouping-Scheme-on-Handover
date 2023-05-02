%Where are you now?
function now = now_gNB(UE,gNB,noise)
clear sinr
max_sinr = -inf;
old_sinr = -inf;
nowgNB = inf;
old = UE.now_gNB;
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
now = [nowgNB max_sinr old_sinr];


