function [ fcorn_m, tstar_m ] = get_fcorn_tstar_grids()

global F_CORN_MIN F_CORN_MAX
global T_STAR_MIN T_STAR_MAX

%f_corn_stp = (F_CORN_MAX - F_CORN_MIN) / 200;
%fcorn_m = F_CORN_MIN : f_corn_stp : F_CORN_MAX;
f_corn_min_log = log(F_CORN_MIN);
f_corn_max_log = log(F_CORN_MAX);
f_corn_stp_log = (f_corn_max_log - f_corn_min_log) / 200;
fcorn_m = exp( f_corn_min_log : f_corn_stp_log : f_corn_max_log );

t_star_min_log = log(T_STAR_MIN);
t_star_max_log = log(T_STAR_MAX);
t_star_stp_log = (t_star_max_log - t_star_min_log) / 200;
tstar_m = exp( t_star_min_log : t_star_stp_log : t_star_max_log );
