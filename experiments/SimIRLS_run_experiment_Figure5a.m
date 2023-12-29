%% Define experiment for Figure 5a (upper row)
% This script is reproduces the experiment of Figure 5 (upper row) in the 
% paper [1], cf. Appendix.
% See 'load_experiment_Figure5a_FourierRankOneMeas_rank1.m' for a script 
% loading the corresponding experimental data.
%
% Reference:
% [1] Christian Kuemmerle, Johannes Maly, "Recovering Simultaneously 
% Structured Data via Non-Convex Iteratively Reweighted Least Squares",
% NeurIPS 2023, 2023, see also arXiv:2306.04961v2.
sparsitys=[1,2:2:40];
ms = 40:5:280;
rho_min = 1.0;rho_max = 4.0;
Examples   = LoadExampleDefinitions;
Params.ExampleName ='LRRS_FourierRank1_rank1_n2_40';
ExampleIdx =SelectExample(Params,Examples);
Example    = Examples{ExampleIdx};
Example.prob.r = 1;

instancesize =64;
Example.opts.n_jobs = 24;
K1_misspecfication_fac = 1;
r_misspecfication_fac = 1;

for i=1:length(sparsitys);
    snippet_LRRS_Gaussian_rank1_successrates;
end