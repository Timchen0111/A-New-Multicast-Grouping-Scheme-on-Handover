function result = overall
%UENUM=50
    parfor i = 1:8
        if i <= 4
            r(i) = main('random',100,600,10,25);
            k(i) = main('kmeans',100,600,10,25);
            gr(i) = main('GRPPD',100,600,10,25);
            gk(i) = main('GKPPD',100,600,10,25);
        else
            r(i) = main('random',100,600,10,30);
            k(i) = main('kmeans',100,600,10,30);
            gr(i) = main('GRPPD',100,600,10,30);
            gk(i) = main('GKPPD',100,600,10,30);
        end
    end

%     for i = 1:6
%         Eff(j,i) = mean(eff(:,i));
%         Reg(j,i) = mean(reg(:,i));
%     end
r
k
gr
gk
result = [r k gr gk];
% writematrix(Eff, 'pingpong_eff.csv');
% writematrix(Reg, 'pingpong_reg_num.csv');
% plot(Eff(:,1),pp,Eff(:,2),pp,Eff(:,3),pp,Eff(:,4),pp,Eff(:,5),pp,Eff(:,6),pp)
% figure(1)
% title('Result with ping-pong effect')
% xlabel('ping-pong timer')
% ylabel('efficiency')
% legend({'random', 'kmeans','GRPPD','GKPPD','GRPPD-UNI','GKPPD-UNI'});




