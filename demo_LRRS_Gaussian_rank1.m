% This script demonstrates of the repository for low-rank and
% row-sparse matrix recovery executing the algorithms 'IRLS-LRRS' [1], 
% 'SparsePowerFactorization' [2] and 'RiemAdaIHT' [3] for an experimental
% setup similar to Figure 1 in [1], cf. file 'LRRS_Gaussian_rank1_def.m'.
%
% References:
% [1] Christian Kuemmerle, Johannes Maly, "Recovering Simultaneously 
% Structured Data via Non-Convex Iteratively Reweighted Least Squares",
% NeurIPS 2023, 2023, see also arXiv:2306.04961.
% [2] Kiryung Lee, Yihong Wu, and Yoram Bresler. Near-optimal compressed 
% sensing of a class of sparse low-rank matrices via sparse power 
% factorization. IEEE Transactions on Information Theory, 64(3):1666–1698,
% 2018, https://doi.org/10.1109/TIT.2017.2784479.
% [3] Henrik Eisenmann, Felix Krahmer, Max Pfeffer, and André Uschmajew. 
% Riemannian thresholding methods for row-sparse and low-rank matrix recovery.
% Numerical Algorithms, pages 1–25, 2022,
% https://doi.org/10.1007/s11075-022-01433-5.

Params = [];
Params.ExampleName = 'LRRS_Gaussian_rank1_n2_40';
Examples   = LoadExampleDefinitions;
ExampleIdx = SelectExample(Params,Examples);
Example    = Examples{ExampleIdx};
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