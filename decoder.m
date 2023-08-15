count = 1;
number = 3;
data = zeros(number,50);
data2 = zeros(number,50);
now = 1;
for i = 1:length(results)
    if count == number+1
        now = now+1;
        count = 1;
    end
    rrr = results{i};
    data(count,now) = rrr(1); 
    data2(count,now) = rrr(2); 
    count = count+1;
end
r = zeros(1,number);
r2 = zeros(1,number);
for i = 1:number
    r(i) = mean(data(i,:));
    r2(i) = mean(data2(i,:));
end
r = r';
r2 = r2';