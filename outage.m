function out = outage(threshold,x)
out = zeros(1,5);
for i = 1:5
    c = cell2mat(x(i));
    a = length(c);
    b = length(c(c<threshold));
    out(1,i) = b/a;
end
