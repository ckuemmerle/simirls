%% Define experiment for Figure 2 (upper row)
% This script is reproduces the experiment of Figure 2 (upper row) in the 
% paper [1], cf. Section 4.
% See 'load_experiment_Figure2a_base_rank5.m' for a script loading the 
% corresponding experimental data.
%
% Reference:
% [1] Christian Kuemmerle, Johannes Maly, "Recovering Simultaneously 
% Structured Data via Non-Convex Iteratively Reweighted Least Squares",
% NeurIPS 2023, 2023, see also arXiv:2306.04961v2.
sparsitys = 20:5:60;
ms=[300:25:1000,1050:50:1500,1600:100:2000];
rho_min = 1.05;rho_max = 3.0;
Examples   = LoadExampleDefinitions;
Params.ExampleName = 'LRRS_Gaussian_rank1_n2_40';
ExampleIdx =SelectExample(Params,Examples);
Example    = Examples{ExampleIdx};
Example.prob.r = 5;

instancesize =64;
Example.opts.n_jobs = 24;
K1_misspecfication_fac = 1;
r_misspecfication_fac = 1;

for i=1:length(sparsitys);
    snippet_LRRS_Gaussian_rank1_successrates;
end