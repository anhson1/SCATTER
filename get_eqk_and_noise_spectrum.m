function [ freq, spct_eqk, spct_noise ] = get_eqk_and_noise_spectrum(...
    src_wave, bgn_time, smprate, arr_time, eqk_time, extract_nsamples)
% Arguments:
% src_wave - source waveform
% bgn_time - timestamp of beginning of source waveform
% smprate - number of samples per second
% arr_time - timestamp of beginning of wave_eqk
% eqk_time - time stamp of earthquake's hypocenter. It is only to make
%   zero reference on plots
% extract_nsamples - number of samples to extract
% all these is for plotting
wv_offs = arr_time - eqk_time; 
rec_offs = bgn_time - eqk_time;
time_wave = (0:(length(src_wave)-1)) / smprate + rec_offs;
if FL_DO_PLOT
    hfig = figure('units','normalized','outerposition',[0 0 1 1]);
    title(FIG_TITLE, 'FontSize', 16);
    hold('on');
    plot(time_wave, src_wave, 'g-');
    ylim([-PLOT_WAVE_SCALE_Y, PLOT_WAVE_SCALE_Y]);
end
% noise
[ wave0, time0 ] = extract_wave(src_wave, bgn_time, bgn_time, (extract_nsamples +0.1) / smprate);
if FL_DO_PLOT
    plot(time0 - eqk_time, wave0, 'm-');
end
wave0 = wave0 - mean(wave0);
wave0 = wave0 .* hamming(extract_nsamples, 'periodic');
if FL_DO_PLOT
    plot(time0 - eqk_time, wave0, 'r-');
end
spct_noise = fft(wave0) / length(wave0);
spct_noise = spct_noise(1:(length(spct_noise)/2+1));
% earthquake
[ wave1, time1 ] = extract_wave(src_wave, bgn_time, arr_time, (extract_nsamples +0.1) / smprate);
if FL_DO_PLOT
    plot([wv_offs wv_offs], [-PLOT_WAVE_SCALE_Y, PLOT_WAVE_SCALE_Y], 'k-', 'LineWidth', 3);
    plot(time1 - eqk_time, wave1, 'c-');
end
wave1 = wave1 - mean(wave1);
wave1 = wave1 .* hamming(extract_nsamples, 'periodic');
if FL_DO_PLOT
    plot(time1 - eqk_time, wave1, 'b-');
end
spct_eqk = fft(wave1) / length(wave1);
spct_eqk = spct_eqk(1:(length(spct_eqk)/2+1));
if FL_DO_PLOT
    saveas(hfig, [ FIG_FNAME '-1wave.png' ], 'png');
    saveas(hfig, [ FIG_FNAME '-1wave.fig' ], 'fig');
    if FL_CLOSE_FIG
        close(hfig);
    end
end
specstep = (smprate / 2) / (length(spct_eqk) - 1);
freq = [ 0:specstep:(smprate / 2 + specstep*0.1) ]';
