% if FL_DO_PLOT not set then no plots will be done
global FL_DO_PLOT
FL_DO_PLOT = 1;

% every plot is always saved as PNG image

% if FL_CLOSE_FIG is set then all plots will be closed after saving as PNG
global FL_CLOSE_FIG
FL_CLOSE_FIG = 1;

% if WRITE_DATA_TO_DB is set then results (omega, corner_frequency, t_star will be stored to DB)
global WRITE_DATA_TO_DB
WRITE_DATA_TO_DB = 1;

% number of samples to compute wave and noise spectrum via Fast Fourier Transformation
global N_SAMPLES_TO_CALC_SPECTRUM
N_SAMPLES_TO_CALC_SPECTRUM = 256;

% scales (axis ranges) for plotting
global PLOT_WAVE_SCALE_Y PLOT_SPCT_SCALE_Y
PLOT_WAVE_SCALE_Y = 1e4;
PLOT_SPCT_SCALE_Y = [ 1e-1 1e5 ];

% wave type (phase) P or S
global WAVE_TYPE
WAVE_TYPE = 'p';

% frequency range for spectrum approximation
global F_APPROX_MIN F_APPROX_MAX
F_APPROX_MIN = 1;
F_APPROX_MAX = 25;

% limits for estimating corner frequency
global F_CORN_MIN F_CORN_MAX
F_CORN_MIN = 0.2;
F_CORN_MAX = 45;

% limits for estimating t*
global T_STAR_MIN T_STAR_MAX
T_STAR_MIN = 0.0001;
T_STAR_MAX = 0.5;

% natural logarithm of earthquake to noise ratio to mark record as bad
global MIN_LOG_SIGNAL_TO_NOISE_RATIO
MIN_LOG_SIGNAL_TO_NOISE_RATIO = log(3);

