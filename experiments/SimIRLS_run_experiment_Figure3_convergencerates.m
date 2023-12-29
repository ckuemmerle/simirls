%% Define experiment for Figure 3
% This script is reproduces the experiment of Figure 3 in the paper
% [1], cf. Section 4.
% The resulting plot files will have "LRRS_Gaussian_rank5_convg_plot" in
% their name. See 'load_experiment_Figure3_convg_plot.m' for a script
% loading the corresponding experimental data.
%
% Reference:
% [1] Christian Kuemmerle, Johannes Maly, "Recovering Simultaneously 
% Structured Data via Non-Convex Iteratively Reweighted Least Squares",
% NeurIPS 2023, 2023, see also arXiv:2306.04961v2.

Examples   = LoadExampleDefinitions;
Params.ExampleName = 'LRRS_Gaussian_rank5_convg_plot';
ExampleIdx = SelectExample(Params,Examples);
Example    = Examples{ExampleIdx};
disp(Example.prob)
disp(Example.samplemodel)
%% Run experiment
[yr,outs] = run_methods_LRRS(Example);
%% Save data
s1=convertCharsToStrings(Example.descr);
filename = strcat('experiments/',s1);
save(strcat(filename,'.mat'),'Example','outs','yr');
save_LRRS_plots;