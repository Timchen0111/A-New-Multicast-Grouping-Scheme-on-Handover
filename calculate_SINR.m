function sinr = calculate_SINR(UE,tgNB_num,gNB,noise) 
tgNB = gNB(tgNB_num);
fc = 3;%frequency

for i=1:19
    distance(i) = norm(UE.pos-gNB(i).pos);
    pl(i) = 0;
end

fad_ = randn(1, 19);
%sigma = 4;
%fad_ = sigma.*fad;

% itemx = floor((UE.pos(1)+900)/2);
% itemy = floor((900-UE.pos(2))/2);
% if itemx < 1
%     itemx = 1;
% elseif itemy < 1
%     itemy = 1;
% elseif itemx > 900
%     itemx = 900;
% elseif itemy > 900
%     itemy = 900;
% end
% 
% %disp(fad_map(itemx,itemy));
% for i = 1:19
%     fad_(i) = fad_map(i,itemx,itemy);
% end

for i=1:19
    result = pathloss(35,1.5,5,distance(i),fc); %Unit:db
    if result(2) == true
        fad = fad_(i)*4;
    else 
        fad = fad_(i)*6;
    end
    pl(i) = 14+19+fad-result(1); %signal, unit:db %11:Antenna gain 19:Tx power
end
interference = 0;
for i=1:19
    if i ~= tgNB_num
        interference = interference+10^(pl(i)/10);
    end
end
Noise = 10^(noise/10);

sinr = pl(tgNB_num)-10*log10(interference+Noise); %db
%disp('sinr')
%disp(sinr)