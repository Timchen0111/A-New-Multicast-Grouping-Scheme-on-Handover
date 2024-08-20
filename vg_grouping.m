function g = vg_grouping(g,allUE)
    % 全域輸入: 單播用戶數量N，多播用戶數量M，多播用戶通道條件排序 c1≤...≤cM, 總資源區塊T, 多播資源比例α
    % 全域輸出: 多播群組數量K*, 多播群組{G*}, 多播資源{x*}
    M = numel(g.joinUE);
    if M == 0
        g.group = [];
        return
    end
    U = -inf(M, M, M); % 初始化效用矩陣
    p = zeros(M, M, M); % 初始化分割位置矩陣
    Umax = -inf; % 初始化最大效用
    Gk = 1:M;
    %對UE依SINR排序
    joinUE = g.joinUE;
    sinr = zeros(1,length(joinUE));
    for i = 1:M
        sinr(1,i) = allUE(joinUE(i)).SINR;
    end
    sort_sinr = sort(sinr);
    [~, sortIndex] = sort(sinr);
    sort_UE = joinUE(sortIndex);

    %%%
    %disp(M)
    for K = 1:M % K總群組
        for i = 1:(M - K + 1) % 初始化
            U(K, i, 1) = utility(K,  Gk,  sort_sinr);
        end
        for k = 2:K % 第一k群組
            for i = k:(M - K + k) % 第一i用戶
                for j = (k - 1):(i - 1) % 在用戶j處分割
                    Gk = (j + 1):i;
                    u = U(K, j, k - 1) + utility(K,  Gk,  sort_sinr);
                    if u > U(K, i, k)
                        U(K, i, k) = u;
                        p(K, i, k) = j;
                    end
                end
            end
        end
        if U(K, M, K) > Umax % 檢查最大效用
            Umax = U(K, M, K);
            K_opt = K;
        end
    end
    G_opt = cell(K_opt, 1);
    %x_opt = zeros(K_opt, 1);
    j = M; % 回溯找到最佳解
    %disp('HAPPYDOG')
    %disp(K_opt)
    for k = K_opt:-1:1
        i = j;
        j = p(K_opt, i, k);
        G_opt{k} = (j + 1):i;
        %disp(G_opt)
        %disp('HAPPYDOG')
        %x_opt(k) = resourceMulti(K_opt, G_opt{k}, T, alpha, N, M);
    end
    g.group = zeros(1,M);
    for k = 1:length(G_opt)
        member = G_opt{k};
        for j = 1:numel(member)
            g.group(1,member(j)) = k;
        end
    end
    g.joinUE = sort_UE;
    g.groupnum = length(G_opt);
    %disp(g)
end


