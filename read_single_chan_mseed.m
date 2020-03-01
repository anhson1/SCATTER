function [wave, bgn_time, smprate, chan_name] = read_single_chan_mseed(mseed)
% [wave, bgn_time, smprate, chan_name] = read_single_chan_mseed(mseed)
% Reads single time series from mseed
% mseed can be:
%   filename (string), in such case rdmseed will be called
%   a sructure with fields X and I, returned by mseed call
% wave is the signal itself
% bgn_time is scalar - unix timestamp for wave(1)

% if we haven't been already given results of rdmseed - then we are given
% a filename
if (~isstruct(mseed))
    tmp = mseed;
    clear mseed
    [mseed.X, mseed.I] = rdmseed(tmp);
    clear tmp
end

if (length(mseed.I) ~= 1)
    error('the mseed contains more than one stations/channels')
end

chan_name = mseed.I.ChannelFullName;

if (length(mseed.I.OverlapBlockIndex) ~= 0)
    error('the mseed contains overlaps')
end
if (length(mseed.I.GapBlockIndex) ~= 0)
    error('the mseed contains gaps')
end

wave_p = cell(size(mseed.I.XBlockIndex));
for i = 1:length(mseed.I.XBlockIndex)
	wave_p{i} = mseed.X(mseed.I.XBlockIndex(i)).d;
end
wave = vertcat(wave_p{:});

bgn_time = (mseed.X(mseed.I.XBlockIndex(1)).RecordStartTimeMATLAB - ...
    datenum('Jan-1-1970 00:00:00')) * 24 *60 * 60;

smprate = mseed.X(mseed.I.XBlockIndex(1)).SampleRate;


