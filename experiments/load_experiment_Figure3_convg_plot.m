%% Load data for Figure 3
% This script is loads the experiment data for Figure 3.
% To reproduce the experiment, please run
% 'SimIRLS_run_experiment_Figure3_convergencerates.m'.
%
% Reference:
% [1] Christian Kuemmerle, Johannes Maly, "Recovering Simultaneously 
% Structured Data via Non-Convex Iteratively Reweighted Least Squares",
% NeurIPS 2023, 2023, see also arXiv:2306.04961v2.
clear
filename = 'LRRS_Gaussian_rank5_convg_plot';
load(filename);
alg_names = get_good_algo_names(Example.alg_name);

visualize_errorcurves_combined(outs.errors.fro_rel,alg_names,'titlestring','');
ylabel('Rel. Frobenius error')
xlabel('Iteration $k$')
filename = 'LRRS_Figure3_Gaussian_rank5_convg_plot';
save_LRRS_plots % enter subfolder 'experiments' before running this script
% for correct location of saved files
