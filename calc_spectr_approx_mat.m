function [omega_m, residual_m] = calc_spectr_approx_mat (fcorn_m, tstar_m, frq, spc)
% Arguments:
% fcorn_m - corner frequency value
% tstar_m - tstar values
% frq - frequency steps
% spc - spectra of the signal
omega_m = nan(length(fcorn_m), length(tstar_m));
residual_m = nan(length(fcorn_m), length(tstar_m));
% weight data for logarithmic x axis
w = nan(size(frq));
for f = 1:(length(frq)-1)
    w(f) = frq(f+1) / frq(f);
end
w(length(frq)) = w(length(frq)-1);
w = w ./ mean(w);

for f = 1:length(fcorn_m)
    for t = 1:length(tstar_m)
        S = frq .* exp(-pi .* frq .* tstar_m(t)) ./ ( 1 + frq.^2 ./ fcorn_m(f).^2 );
       
        omega_m(f, t) = exp(mean( log(spc ./ S) .* w ));
        residual_m(f, t) = norm ( (log(spc) - log( omega_m(f, t) .* S )) .* w );
    end
end

