function [ frq, spc ] = cut_approxed_amp_spectrum(freq, spectrum)
% Arguments:
% freq - frequency steps
% spectrum - spectra values
frq = freq(F_APPROX_MIN <= freq & freq < F_APPROX_MAX);
spc = abs(spectrum(F_APPROX_MIN <= freq & freq < F_APPROX_MAX));

