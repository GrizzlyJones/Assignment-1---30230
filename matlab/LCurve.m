function fig = LCurve(rms, m_norm, alpha, selection)
    fig = figure;
    
    % Data plot
    loglog(rms, m_norm)
    hold on

    % Plot alpha values
    xt = rms(selection);
    yt = m_norm(selection);
    strt = strtrim(cellstr(num2str(alpha(selection)'))');           % Alpha value to cell of strings
    loglog(xt, yt, 'o', 'color', [0 0.4470 0.7410]);                % Marker
    text(xt,yt,strt,'verticalAlignment', 'bottom', 'fontSize', 16)  % Text

    % Plot meta data
    ylabel('Model norm');
    xlabel('RMS misfit');
    xlim([rms(1), rms(end)])
    grid on;
end