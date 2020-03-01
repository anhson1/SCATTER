% test_extract_wave.m

[data, bgn_time, smprate, chan_name] = ... 
    read_single_chan_mseed('../data/path_to_mseed');

[ data1, time1 ] = extract_wave(data, bgn_time, 1242168518, 20);

spectrum = fft(data1);

specstep = (smprate / 2) / (length(spectrum) - 1);

spec_f = 0:specstep:(smprate / 2 + specstep*0.1);

figure;
plot(time1 - bgn_time, data1);

figure;
loglog(spec_f, abs(spectrum));


