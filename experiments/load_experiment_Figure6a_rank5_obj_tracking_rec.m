%% Load data for Figure 6a
% This script is loads the experiment data for Figure 6a, in the appendix of
% the paper [1].
% To reproduce the experiment, please run
% 'SimIRLS_run_experiment_Figure6a.m'.
%
% Reference:
% [1] Christian Kuemmerle, Johannes Maly, "Recovering Simultaneously 
% Structured Data via Non-Convex Iteratively Reweighted Least Squares",
% NeurIPS 2023, 2023, see also arXiv:2306.04961v2.
clear
filename = 'LRRS_Gaussian_rank5_obj_tracking_rec';
load(filename);
openfig(filename);
