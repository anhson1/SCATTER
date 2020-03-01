function spec_OK = check_plot_spectrum(freq, eqk_spec, noise_spec)
% Arguments:
% freq - frequency steps
% eqk_spec - signal spectrum
% noise_spec - noise spectrum
eqk_spec = abs(eqk_spec);
noise_spec = abs(noise_spec);
log_eqk_spec = log(eqk_spec);
log_noise_spec = log(noise_spec);
% apply haussian smoothing
khauss = 5;
spect_len = length(log_eqk_spec);
gaussian = gaussfir(khauss/spect_len, round(spect_len/khauss));
strip_conv = (length(gaussian) - 1) / 2;
log_eqk_spec_sm = conv(log_eqk_spec, gaussian);
log_eqk_spec_sm = log_eqk_spec_sm((strip_conv + 1):(strip_conv + spect_len));
log_noise_spec_sm = conv(log_noise_spec, gaussian);
log_noise_spec_sm = log_noise_spec_sm((strip_conv + 1):(strip_conv + spect_len));
bad_idxs = find(log_eqk_spec_sm - log_noise_spec_sm < MIN_LOG_SIGNAL_TO_NOISE_RATIO & F_APPROX_MIN <= freq & freq < F_APPROX_MAX);
spec_OK = length(bad_idxs) == 0;
if FL_DO_PLOT
    hfig = figure('units','normalized','outerposition',[0 0 1 1]);
    hold('on');
    plot(freq, noise_spec, 'm-', freq, eqk_spec, 'b-');
    plot(freq, exp(log_noise_spec_sm), 'm-', freq, exp(log_eqk_spec_sm), 'b-', 'LineWidth', 2);
    plot(freq(bad_idxs), exp(log_eqk_spec_sm(bad_idxs)), 'r.', 'MarkerSize', 10);
    axis([1, 50, PLOT_SPCT_SCALE_Y]);
    set(gca, 'XScale', 'log')
    set(gca, 'YScale', 'log')
    title(FIG_TITLE, 'FontSize', 16);
    if spec_OK
        txt = 'OK';
    else
        txt = 'BAD';
    end
    text(10, PLOT_SPCT_SCALE_Y(1)^0.1 * PLOT_SPCT_SCALE_Y(2)^0.9, txt, 'FontSize', 20);
    saveas(hfig, [ FIG_FNAME '-2spect.png' ], 'png');
    % saveas(hfig, [ FIG_FNAME '-2spect.fig' ], 'fig');
    if FL_CLOSE_FIG
        close(hfig);
    end
end



