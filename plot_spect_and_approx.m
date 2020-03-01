function plot_spect_and_approx(freq, spectrum, omega1, fcorn, tstar, ...
   residual, freq2, spectrum2)
% plot_spect_and_approx(freq, spectrum, omega1, fcorn, tstar, ...
%   residual = [], freq2 = [], srectrum2 = [])
% plots spectrum, and it's approximation as 
% approx = omega1 .* exp(-pi .* freq .* tstar) ./ ( 1 + freq.^2 ./ fcorn.^2 );
% approx = freq .* approx; % convert position spectrum to velocity spectrum
% if freq2, srectrum2 are present, they are plot too, for comparison

global FL_DO_PLOT
global FL_CLOSE_FIG
global FIG_TITLE FIG_FNAME
global PLOT_WAVE_SCALE_Y PLOT_SPCT_SCALE_Y

if ( ~exist('residual', 'var') )
    residual = [];
end
if ( ~exist('freq2', 'var') )
    freq2 = [];
    spectrum2 = [];
end

[ frq, spc ] = cut_approxed_amp_spectrum(freq, spectrum);

approx = omega1 .* exp(-pi .* frq .* tstar) ./ ( 1 + frq.^2 ./ fcorn.^2 );
approx = frq .* approx; % convert position spectrum to velocity spectrum

if FL_DO_PLOT
    hfig = figure('units','normalized','outerposition',[0 0 1 1]);
    loglog(freq2, abs(spectrum2), 'r-', freq, abs(spectrum), 'g-', frq, abs(spc), 'b-', frq, approx, 'k-', 'LineWidth', 2);
    hold('on');
    axis([1, 50, PLOT_SPCT_SCALE_Y]);
    str = sprintf('\\Omega'' = %0.2f\nf_c = %0.2f\nt\\ast = %0.4f\nresidual = %0.4f', omega1, fcorn, tstar, residual);
    text(1.5, PLOT_SPCT_SCALE_Y(1)^0.8 * PLOT_SPCT_SCALE_Y(2)^0.2, str, 'FontSize', 16);
    title(FIG_TITLE, 'FontSize', 16);
    saveas(hfig, [ FIG_FNAME '-4approx.png' ], 'png');
    % saveas(hfig, [ FIG_FNAME '-4approx.fig' ], 'fig');
    if FL_CLOSE_FIG
        close(hfig);
    end
end

