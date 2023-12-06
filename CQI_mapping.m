function cqi = CQI_mapping(snr)
    % Table III: SNR-CQI Mapping for 64QAM
    snr_values = [-11.2, -9.1, -6.9, -4.4, -2.2, 0.7, 2.7, 4.3, 6.9, 8.5, 10.6, 12.4, 14.4, 17.5, 20.9];
    cqi_values = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
    
    % Interpolate CQI for given SNR
    cqi = interp1(snr_values, cqi_values, snr, 'linear', 'extrap');
    cqi = floor(cqi);
    if cqi<1
        cqi =1;
    elseif cqi>15
        cqi = 15;
    end
end


