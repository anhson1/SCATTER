function [ omega1, fcorn, tstar ] = calc_spect_params(freq, spectrum)

[ frq, spc ] = cut_approxed_amp_spectrum(freq, spectrum);

[ fcorn_m, tstar_m ] = get_fcorn_tstar_grids();

[omega_m, residual_m] = calc_spectr_approx_mat (fcorn_m, tstar_m, frq, spc);

mm = min(min(residual_m));
[f, t] = find(residual_m == mm, 1);

fcorn = fcorn_m(f);
tstar = tstar_m(t);
omega1 = omega_m(f, t);

plot_residual_matrix(tstar_m, fcorn_m, residual_m, tstar, fcorn)
