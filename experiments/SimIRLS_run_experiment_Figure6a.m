%% Define experiment for Figure 6a
% This script is reproduces the experiment of Figure 6a in the paper
% [1], cf. Appendix.
% The resulting plot files will have "LRRS_Gaussian_rank5_obj_tracking_rec" 
% in their name. See 'load_experiment_Figure6a_rank5_obj_tracking_rec.m' 
% for a script loading the corresponding experimental data.
%
% Reference:
% [1] Christian Kuemmerle, Johannes Maly, "Recovering Simultaneously 
% Structured Data via Non-Convex Iteratively Reweighted Least Squares",
% NeurIPS 2023, 2023, see also arXiv:2306.04961v2.

Examples   = LoadExampleDefinitions;
Params.ExampleName = 'LRRS_Gaussian_rank5_obj_tracking_rec';
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