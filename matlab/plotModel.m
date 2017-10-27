function fig = plotModel(lat, dB_z, dB_x, GB_z, GB_x, m_ls)
    fig = figure;
    hold on;
    
    % Data plots
    p1 = plot(lat, dB_z, '--', 'Color', [0 0.447 0.741 0.5]);
    p2 = plot(lat, dB_x, '--', 'Color', [0.85 0.325 0.098 0.5]);
    p3 = plot(lat, GB_z*m_ls, 'Color', [0 0.447 0.741]);
    p4 = plot(lat, GB_x*m_ls, 'Color', [0.85 0.325 0.098]);
    
    % Plot meta data
    grid on;
    xlim([lat(1), lat(end)]);
    xlabel('Latitude [deg]');
    ylabel('Magnetic intensity [nT]');
    legend([p3, p4, p1, p2], 'Model B_z','Model B_x', 'Observed B_z', 'Observed B_x', 'location', 'sw');
end