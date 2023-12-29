%% Define experiment for Figure 6b
% This script is reproduces the experiment of Figure 6b (second column) in 
% the paper [1], cf. Appendix.
% The resulting plot files will have "LRRS_Gaussian_rank5_obj_tracking" 
% in their name. See 'load_experiment_Figure6b_rank5_obj_tracking.m' 
% for a script loading the corresponding experimental data.
%
% Reference:
% [1] Christian Kuemmerle, Johannes Maly, "Recovering Simultaneously 
% Structured Data via Non-Convex Iteratively Reweighted Least Squares",
% NeurIPS 2023, 2023, see also arXiv:2306.04961v2.

Examples   = LoadExampleDefinitions;
Params.ExampleName = 'LRRS_Gaussian_rank5_obj_tracking';
ExampleIdx = SelectExample(Params,Examples);
Example    = Examples{ExampleIdx};
disp(Example.prob)
disp(Example.samplemodel)
%% Run experiment
[yr,outs] = run_methods_LRRS(Example);
%% Save data
s1=Example.descr;
filename = strcat('experiments/',s1);
save(strcat(filename,'.mat'),'Example','outs','yr');
figure(outs.objfigure);
save_LRRS_plots;