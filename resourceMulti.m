function xk = resourceMulti(K, g,Gk)
    % 輸入: 群組數量K, 多播群組Gk
    % 輸出: 群組資源xk
    if length(Gk) == 1
        xk = T / (K + N);
    elseif length(Gk) == M
        if alpha >= M / (M + N)
            xk = (length(Gk) / (M + N)) * T;
        else
            xk = (length(Gk) / M) * alpha * T;
        end
    else
        xk = (length(Gk) / (M + N)) * T;
    end
end