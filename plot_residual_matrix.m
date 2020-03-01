function plot_residual_matrix(tstar_m, fcorn_m, residual_square, tstar, fcorn)

global FL_DO_PLOT
global FL_CLOSE_FIG
global FIG_TITLE FIG_FNAME

if FL_DO_PLOT
    hfig = figure('units','normalized','outerposition',[0 0 1 1]);
    hold('on');
    %colormap(hot(1024));
    h = pcolor( tstar_m, fcorn_m, log(residual_square) ); % log(log(residual_square + 1))
    set(h,'EdgeColor','none');
    set(gca, 'XScale', 'log')
    set(gca, 'YScale', 'log')
    colorbar;
    plot(tstar, fcorn, 'k+', 'MarkerSize', 20, 'LineWidth', 3);
    title(FIG_TITLE, 'FontSize', 16);
    saveas(hfig, [ FIG_FNAME '-3resid.png' ], 'png');
    % saveas(hfig, [ FIG_FNAME '-3resid.fig' ], 'fig');
    if FL_CLOSE_FIG
        close(hfig);
    end
end

