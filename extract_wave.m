function [res, time] = extract_wave(wave, bgn_time, extract_from, extract_len, smprate)
% Arguments:
% wave - waveform data
% bgn_time - absolute time of waveform
% extract_from - start position for extracting data for processing
% extract_len - length of extracted data
% smprate - sample rate of data
if(~exist('smprate', 'var'))
    smprate = 100;
end
if(extract_from < bgn_time)
    error('TSTAR:SHORT_WAVE', 'extract_wave: extract_from < bgn_time')
end
first_idx = floor((extract_from - bgn_time) * smprate) + 1;
last_idx = first_idx - 1 + floor(extract_len * smprate);
if(last_idx > length(wave))
    error('TSTAR:SHORT_WAVE', 'extract_wave: last_idx > lenght(wave)')
end
idxs = first_idx:last_idx;
time = bgn_time + (idxs - 1) / smprate;
res = wave(first_idx:last_idx);

