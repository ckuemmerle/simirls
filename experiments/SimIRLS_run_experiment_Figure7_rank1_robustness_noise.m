%% Define experiment for Figure 7
% This script is reproduces the experiment of Figure 7 in the paper
% [1], cf. Appendix.
% See 'load_experiment_Figure7_noisy_Gaussian.m' for a script 
% loading the corresponding experimental data.
%
% Reference:
% [1] Christian Kuemmerle, Johannes Maly, "Recovering Simultaneously 
% Structured Data via Non-Convex Iteratively Reweighted Least Squares",
% NeurIPS 2023, 2023, see also arXiv:2306.04961v2.

Examples   = LoadExampleDefinitions;
Params.ExampleName = 'LRRS_Gaussian_rank1_noisy_n2_40';
ExampleIdx = SelectExample(Params,Examples);
Example    = Examples{ExampleIdx};
%% Choose algorithmic parameters
paras_experiment = struct;
paras_experiment.name = 'SNR';
paras_experiment.values = logspace(-1,16,18);
instancesize = 128;
Example.opts.n_jobs = 24;
Example.optsfct.parallel = true;
Example.opts.N0          = 100;
Example.opts.verbose   = false;
Example.prob.add_noise = true;
Example.optsfct.verbose   = false;
Example.alg_name = {'RiemannianIHT_adap','SparsePowerFactorization','IRLS-LRRS'};
Example.samplemodel.oversampling = 3;
option = [];
option = 'loglog';
filename_note={'prob','r'};
resultname = 'avg_error_rel';
resulttext = 'Avg. rel. Frobenius error';
%% Run experiment & save data
wrapper_experiment_LRRS(Example,...
    paras_experiment,instancesize,resultname,resulttext,option,filename_note);