function fig = plotCovCorr(C_m)
    fig = figure;
    colormap(gray);
    imagesc(C_m);
    set(gca, 'Ydir', 'Normal');
    xlabel('Line current number');
    ylabel('Line current number');
    colorbar;
end