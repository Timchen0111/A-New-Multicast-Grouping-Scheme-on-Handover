R = [a1' a2' a3' a4' a5' a6' a7' a8' a9' a10']';
r = zeros(1,10);
RR = R(:,1);
for i = 1: length(RR)/4
    r(i) = mean(RR(1:4));
    RR(1:4) = [];
end
r = r';
