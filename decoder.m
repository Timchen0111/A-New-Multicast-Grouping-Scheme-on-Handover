count = 1;
number = 8;
data = zeros(number,50);
now = 1;
for i = 1:length(results)
    if count == number+1
        now = now+1;
        count = 1;
    end
    data(count,now) = results{i}; 
    count = count+1;
end
r = zeros(1,number);
for i = 1:number
    r(i) = mean(data(i,:));
end
r = r';