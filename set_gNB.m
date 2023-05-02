function gNB = set_gNB(g,UE_num,K)
gNB = g;
for i=1:19
    gNB(i).num = i;    
end

for i=1:7
    gNB(i).joinUE = [];
    gNB(i).waitingUE = [];
    gNB(i).scUE = [];
    gNB(i).group = [];
    gNB(i).groupnum = K;
    for j=1:K
        gNB(i).worstSINR(j) = inf;
    end
end

gNB(1).pos = [0,0];
gNB(2).pos = [500,0];
gNB(3).pos = [250,250*sqrt(3)];
gNB(4).pos = [-250,250*sqrt(3)];
gNB(5).pos = [-500,0];
gNB(6).pos = [-250,-250*sqrt(3)];
gNB(7).pos = [250,-250*sqrt(3)];
gNB(8).pos = [1000,0];
gNB(9).pos = [750,250*sqrt(3)];
gNB(10).pos = [500,500*sqrt(3)];
gNB(11).pos = [0,500*sqrt(3)];
gNB(12).pos = [-500,500*sqrt(3)];
gNB(13).pos = [-750,250*sqrt(3)];
gNB(14).pos = [-1000,0];
gNB(15).pos = [-750,-250*sqrt(3)];
gNB(16).pos = [-500,-500*sqrt(3)];
gNB(17).pos = [0,-500*sqrt(3)];
gNB(18).pos = [500,-500*sqrt(3)];
gNB(19).pos = [750,-250*sqrt(3)];
