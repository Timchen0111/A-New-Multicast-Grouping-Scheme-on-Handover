function s = fading_generation(s,count)
disp('now: number')
disp(count)
fad = zeros(15,19,900,900);
for i = 1:15
     s = shadow_fading(s,4,900);    
     fad(i,:,:,:) = s;
end
fad = round(fad,2);

n = num2str(count);
save(['t2_' n],'fad');
