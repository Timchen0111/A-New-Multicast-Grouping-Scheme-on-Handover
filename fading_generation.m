function s = fading_generation(s,count)
disp('now: number')
disp(count)
fad = zeros(10,19,900,900);
for i = 1:30
    s = shadow_fading(s,4,900);
    fad(1,:,:,:) = s;
end
save_path = 'C:\fad\';
n = num2str(count);
save(fullfile(save_path,['t' n]),'fad');
