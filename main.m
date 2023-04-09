function main = main(mode,UE_num,time)
switch mode
     case 'unicast'
        error('Not finished')
     case 'greedy' 
        error('Not finished')
     case 'kmeans'
        disp('K-means');
        %{
        dropnum = input('How many UEs be dropped out should we regroup?');
        dropout = input('Durable SINR(db)');
        K = input('Number of group');
        %}
        dropnum = 5;
        dropout = 5;
        K = 5;
        simulation(UE_num,time,dropnum,dropout,K,'kmeans')
     case 'random'
        disp('Grouping randomly');
        %{
        dropnum = input('How many UEs be dropped out should we regroup?');
        dropout = input('Dropout value');
        K = input('Number of group');
        %}
        dropnum = 5;
        dropout = 5;
        K = 5;
        simulation(UE_num,time,dropnum,dropout,K,'random')
     case 'GRPPD'
        disp('Grouping randomly and Ping-Pong Detection');
        %{
        dropnum = input('How many UEs be dropped out should we regroup?');
        dropout = input('Dropout value');
        K = input('Number of group');
        %}
        dropnum = 5;
        dropout = 5;
        K = 5;
        simulation(UE_num,time,dropnum,dropout,K,'GRPPD')
    case 'GKPPD'
        disp('Grouping with Ping-Pong Detection and Kmeans.');
        %{
        dropnum = input('How many UEs be dropped out should we regroup?');
        dropout = input('Dropout value');
        K = input('Number of group');
        %}
        dropnum = 10;
        dropout = 5;
        K = 10;
        simulation(UE_num,time,dropnum,dropout,K,'GKPPD')
     case 'GRPPD-UNI'
        disp('Grouping randomly and Ping-Pong Detection. Using unicast for UE in HO.');
        %{
        dropnum = input('How many UEs be dropped out should we regroup?');
        dropout = input('Dropout value');
        K = input('Number of group');
        %}
        dropnum = 5;
        dropout = 5;
        K = 5;
        simulation_uni(UE_num,time,dropnum,dropout,K,'GRPPD')
     case 'GKPPD-UNI'
        disp('Grouping with Ping-Pong Detection and Kmeans. Using unicast for UE in HO.');
        %{
        dropnum = input('How many UEs be dropped out should we regroup?');
        dropout = input('Dropout value');
        K = input('Number of group');
        %}
        dropnum = 10;
        dropout = 5;
        K = 10;
        simulation_uni(UE_num,time,dropnum,dropout,K,'GKPPD')
     otherwise
        error( 'WRONG USE.' )
 end

