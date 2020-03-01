
filename = '../data/path_to_mseed'
[ wave, bgn_time, smprate, chan_name ] = read_single_chan_mseed(filename);

disp(['smprate = ', smprate]);
disp(['bgn_time = ', bgn_time]);
disp(['chan_name = ', chan_name]);
disp(wave); 
