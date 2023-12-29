function Example = LRRS_Gaussian_rank1_noisy_def()
%LRRS_Gaussian_phasetransition_def This function defines the problem
% parameters of a simple experiment for low-rank and row-sparse matrix
% recovery from dense Gaussian measurements, cf. [1]. It differs from other
% examples as additive measurement noise is added.
%
% Reference:
% [1] Christian Kuemmerle, Johannes Maly, "Recovering Simultaneously 
% Structured Data via Non-Convex Iteratively Reweighted Least Squares",
% NeurIPS 2023, 2023, see also arXiv:2306.04961.
descr = 'LRRS_Gaussian_rank1_noisy_n2_40';
%% Choose problem parameters
prob = struct;

prob.n1 = 256; % number of rows
prob.n2 = 40; % number of columns
prob.K1 = 40; % row sparsity of ground truth
prob.r  = 1;  % rank of ground truth
prob.modeX0  = 1; % mode for creation of ground truth
prob.complex = 0; % boolean determining whether ground truth is complex or not
prob.add_noise = true;
prob.SNR = 1e2;
%% Choose sampling scheme
samplemodel = struct;
samplemodel.mode =  'Gaussian_dense';
samplemodel.oversampling = 3.0;
samplemodel = prepare_samplemodel_LRRS(prob,samplemodel);
%% Choose plotting parameters
optsfct = struct;
optsfct.plot = struct;
optsfct.plot.errors                 = true;
optsfct.plot.timing                 = true;
optsfct.plot.input              = true;
optsfct.verbose = true;
%% Choose algorithmic parameters
alg_name = {'IRLS-LRRS','SparsePowerFactorization','RiemannianIHT_adap'};
opts = struct;
opts.rankpara      = prob.r; % rank parameter used as an input for reconstruction algorithm. Should be equal to the rank of ground truth for best results.
opts.rowspara      = prob.K1; % sparsity parameter for group sparsity used as input for reconstruction algorithm.
opts.verbose       = 2;
opts.K1          = prob.K1;
opts.r           = prob.r;
opts.N0          = 250; % max. number of outer IRLS iterations
opts.N0_inner    = 100; % max. number of inner IRLS iterations in algorithm
opts.N0_firstorder = 2000;
opts.tol_CG      = 1e-13;
opts.tol         = 1e-10;
opts.mu          = 0;
opts.saveiterates = 1;
opts.mode = 'full';

Example = zipExample(descr,prob,samplemodel,optsfct,opts,alg_name);
end

