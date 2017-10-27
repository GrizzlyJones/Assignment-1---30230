function save2eps(filename, xy, fig)
    global printPlots
    if printPlots
        switch nargin
            case nargin == 3
                set(fig, 'PaperPosition', [0 0 xy]);
            case nargin == 2
                set(gcf, 'PaperPosition', [0 0 xy]);
            otherwise
                set(gcf, 'PaperPosition', [0 0 [9 6]]);
        end
        print(filename, '-depsc');
    end
end
