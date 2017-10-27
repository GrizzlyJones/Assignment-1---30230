function fig = plotLC(x_I, m_ls, alpha_bestIndex)
    fig = figure;
    hold on;
    plot(x_I, m_ls(:,alpha_bestIndex), '--', 'color', [0 0.447 0.741 0.5]);
    plot(x_I, m_ls(:,alpha_bestIndex), '*', 'color', [0 0.447 0.741]);
    xlabel('Line current location [deg lat]');
    ylabel('Line current [kA]');
end