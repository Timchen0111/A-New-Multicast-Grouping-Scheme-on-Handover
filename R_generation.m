function R = R_generation(index,md,init)
md2 = 2;
if init == 0
    R = [1 cf(md) cf(2*md) cf(md) cf(sqrt(2)*md);cf(md) 1 cf(md) cf(sqrt(2)*md) cf(md);cf(2*md) cf(md) 1 cf(sqrt(5)*md) cf(sqrt(2)*md);cf(md) cf(sqrt(2)*md) cf(sqrt(5)*md) 1 cf(md);cf(sqrt(2)*md) cf(md) cf(sqrt(2)*md) cf(md) 1];
else
    %加入時間維度：視為一立體空間，時間為第三維，一時間單位距離暫定為一格空間距離
    R = [1 cf(sqrt(3)*md) cf(sqrt(2)*md) cf(sqrt(3)*md) cf(sqrt(2)*md) cf(md);cf(sqrt(3)*md) 1 cf(md) cf(2*md) cf(md) cf(sqrt(2)*md);cf(sqrt(2)*md) cf(md) 1 cf(md) cf(sqrt(2)*md) cf(md);cf(sqrt(3)*md) cf(2*md) cf(md) 1 cf(sqrt(5)*md) cf(sqrt(2)*md);cf(sqrt(2)*md) cf(md) cf(sqrt(2)*md) cf(sqrt(5)*md) 1 cf(md);cf(md) cf(sqrt(2)*md) cf(md) cf(sqrt(2)*md) cf(md) 1];
end
if index ==1
    return 
end
add = [];
for i = 1:index
    if i >2
        add(1:i-2) = [cf(md2)];
    end
    if i == 1
        continue
    end
    if init == 0
        R = [[add cf(sqrt(md2^2+2*md^2)) cf(sqrt(md2^2+md^2)) cf(sqrt(md2^2+2*md^2)) cf(sqrt(md2^2+md^2)) cf(md2)];R];
        R = [[1 add cf(sqrt(md2^2+2*md^2)) cf(sqrt(md2^2+md^2)) cf(sqrt(md2^2+2*md^2)) cf(sqrt(md2^2+md^2)) cf(md2)]',R];
    else
        R = [[add cf(sqrt(md2^2+md^2)) cf(sqrt(md2^2+2*md^2)) cf(sqrt(md2^2+md^2)) cf(sqrt(md2^2+2*md^2)) cf(sqrt(md2^2+md^2)) cf(md2)];R];
        R = [[1 add cf(sqrt(md2^2+md^2)) cf(sqrt(md2^2+2*md^2)) cf(sqrt(md2^2+md^2)) cf(sqrt(md2^2+2*md^2)) cf(sqrt(md2^2+md^2)) cf(md2)]',R];
    end
end