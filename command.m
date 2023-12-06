clear all; close all;
%% Example for sumbiting jobs to MATLAB Distributed Computing Server
%% F
jm = parcluster();
job = createJob(jm);
% input = [matrixSize, simulation Time]
t = 1;
UE = 10;
K = 3;
ppt = 10.24;
ho = 6;
SimConfig = [];

for i = 1:2
    SimConfig = [SimConfig;[5,UE,t,3,ppt,ho]];%;[6,UE,t,3,ppt,ho];[7,UE,t,3,ppt,ho];[6,UE,t,1,ppt,ho]];
end


for i = 1:size(SimConfig,1)
    createTask(job, @main, 1, num2cell([SimConfig(i,:)])); % 2為輸出數量 SimConfig為輸入參數
end
disp('start!')


%c = parcluster('myRemoteClusterProfile');

tic;
submit(job);
% %% get simulation progress from ValueStore
% storeTime = job.ValueStore;
% storeTime.KeyUpdatedFcn = @handleNewEntry;
% %% Wait for finishing
wait(job);
toc

%% Getting Result
results = getAllOutputArguments(job); % cell array 型態 { }

%% kill job
destroy(job); %取出結果後記得清除job，以免堆積過多