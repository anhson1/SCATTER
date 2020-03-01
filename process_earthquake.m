function process_earthquake(eq_rec)
% Arguments:
% eq_rec - event information
eqk_timestamp = eq_rec.origin_times
str_eq_rec_timestamp = sprintf('%.0f',eq_rec.origin_time)
waves = sql([ 'SELECT `station` as station, `arrival_time` as arrival_time, `miniseed_file` as miniseed_file ' ...
    ' FROM arrivals ' ...
    ' WHERE phase = "' WAVE_TYPE '" AND key = "' eq_rec.id '"  ' ...
    ' ' ]);
num_of_good_stations = 0;
spct_eqk_cell = {};
spct_noise_cell = {};
wave_info = struct('stn', {}, 'chan_name', {});
for wv = waves'
    try
        stn = wv.station;
        % find name of data file
        miniseed_file = [ PREPARED_MSEED_PATH '/' wv.miniseed_file ];
        arr_timestamp = wv.arrival_time
        % load data
        [ wave, bgn_time, smprate, chan_name ] = read_single_chan_mseed(miniseed_file);
        disp(['smprate = ', smprate]);
        disp(['bgn_time = ', bgn_time]);
        disp(['chan_name = ', chan_name]);
        % set info for plotting
        if FL_DO_PLOT
            FIG_TITLE = [ str_eq_rec_timestamp ' - ' chan_name ];
            FIG_FNAME = [ OUT_RESULT_PATH str_eq_rec_timestamp '-' chan_name ];
            FIG_FNAME = strrep(FIG_FNAME, ' ', '_');
            FIG_FNAME = strrep(FIG_FNAME, ':', '_');
        end
        % compute spectrums
        [ freq, spct_eqk, spct_noise ] = get_eqk_and_noise_spectrum( ...
            wave, bgn_time, smprate, str2num(arr_timestamp), str2num(eqk_timestamp), N_SAMPLES_TO_CALC_SPECTRUM );
        if ~ check_plot_spectrum(freq, spct_eqk, spct_noise)
            error('TSTAR:BAD_SNR', 'Bad signal to noise ratio')
        end
        num_of_good_stations = num_of_good_stations + 1;
        spct_eqk_cell{num_of_good_stations} = spct_eqk;
        spct_noise_cell{num_of_good_stations} = spct_noise;
        wave_info(num_of_good_stations).stn = stn;
        wave_info(num_of_good_stations).chan_name = chan_name;
    catch
        e = lasterror;
        if strncmp(e.identifier, 'TSTAR:', 6)
            warning_message = [ 'file "' miniseed_file '" not processed: ' e.message ];
            warning_message = strrep(warning_message, '\','/');
            warning (e.identifier, warning_message);
            if FL_DO_PLOT && FL_CLOSE_FIG
                close all;
            end
        else
            disperror
            rethrow(e);
        end
    end
end
[ fcorn_m, tstar_m ] = get_fcorn_tstar_grids();
Res = struct('tstar', {}, 'omega1', {}, 'residual', {});
ResMat = struct('omega_m', {}, 'residual_m', {});
for stn_i = 1:num_of_good_stations
    [ frq, spc ] = cut_approxed_amp_spectrum(freq, spct_eqk_cell{stn_i});
    [ ResMat(stn_i).omega_m, ResMat(stn_i).residual_m ] = calc_spectr_approx_mat (fcorn_m, tstar_m, frq, spc);
end
f_sum_residual = zeros(size(fcorn_m));
for f = 1:length(fcorn_m)
    for stn_i = 1:num_of_good_stations
        f_sum_residual(f) = f_sum_residual(f) + min(ResMat(stn_i).residual_m(f, :));
    end
end
min_f_res = min(f_sum_residual);
f = find(f_sum_residual == min_f_res, 1);
fcorn = fcorn_m(f);
for stn_i = 1:num_of_good_stations
    min_t_res = min(ResMat(stn_i).residual_m(f, :));
    t = find(ResMat(stn_i).residual_m(f, :) == min_t_res, 1);
    Res(stn_i).tstar = tstar_m(t);
    Res(stn_i).omega1 = ResMat(stn_i).omega_m(f, t);
    Res(stn_i).residual = ResMat(stn_i).residual_m(f, t);
end
for stn_i = 1:num_of_good_stations
    tstar = Res(stn_i).tstar;
    omega1 = Res(stn_i).omega1;
    residual = Res(stn_i).residual;
    stn = wave_info(stn_i).stn;
    chan_name = wave_info(stn_i).chan_name;
    % set info for plotting
    if FL_DO_PLOT
        FIG_TITLE = [ str_eq_rec_timestamp ' - ' chan_name ];
        FIG_FNAME = [ OUT_RESULT_PATH str_eq_rec_timestamp '-' chan_name ];
        FIG_FNAME = strrep(FIG_FNAME, ' ', '_');
        FIG_FNAME = strrep(FIG_FNAME, ':', '_');
    end
    if WRITE_DATA_TO_DB
        if(WAVE_TYPE == 'p')
            table_name = 'tstar_result_p';
        else
            table_name = 'tstar_result_s';
        end
        sql([ 'INSERT INTO `' table_name '` '...
            '( corner_frequency   , tstar, omega , station , channel     , event_id) VALUES ' ... 
            '( %f   , %f   , %f    , "%s", "%s"     , %d )' ], ...
               fcorn, tstar, omega1, stn , chan_name, eq_rec.id);
    end
    plot_residual_matrix(tstar_m, fcorn_m, ResMat(stn_i).residual_m, tstar, fcorn);
    plot_spect_and_approx(freq, spct_eqk_cell{stn_i}, omega1, fcorn, tstar, residual, freq, spct_noise_cell{stn_i})
end
return
