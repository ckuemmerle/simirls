% This script demonstrates of the repository for low-rank and
% row-sparse matrix recovery executing the algorithm 'IRLS-LRRS' [1] for 
% an experimental setup similar to Figure 1 in [1], cf. file 
% 'LRRS_Gaussian_rank1_def.m'.
%
% References:
% [1] Christian Kuemmerle, Johannes Maly, "Recovering Simultaneously 
% Structured Data via Non-Convex Iteratively Reweighted Least Squares",
% NeurIPS 2023, 2023, see also arXiv:2306.04961.
Params = [];
Params.ExampleName = 'LRRS_Gaussian_rank1_n2_40';
Examples   = LoadExampleDefinitions;
ExampleIdx = SelectExample(Params,Examples);
Example    = Examples{ExampleIdx};
Example.alg_name = {'IRLS-LRRS'}; % choose only IRLS algorithm
Example.opts.verbose = 2; % option to display full text output each iterate
fprintf("Problem description: \n")
disp(Example.descr)
fprintf("\nExample.samplemodel: \n")
disp(Example.samplemodel)
fprintf("Example.prob: \n")
disp(Example.prob)
fprintf("Algorithms to be used: \n")
disp(Example.alg_name)
%% Run experiment
[yr,outs] = run_methods_LRRS(Example);
s1=convertCharsToStrings(Example.descr);
s3=convertCharsToStrings('.mat');
save(strcat('experiments/',strcat(s1,s3)),'Example','outs','yr');