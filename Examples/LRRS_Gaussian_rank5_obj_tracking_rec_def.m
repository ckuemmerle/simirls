function Example = LRRS_Gaussian_rank5_obj_tracking_rec_def()
%LRRS_Gaussian_rank5_obj_tracking_rec_def This function defines the problem
% parameters used in Figure 6 (first part) of [1].
%
% Reference:
% [1] Christian Kuemmerle, Johannes Maly, "Recovering Simultaneously 
% Structured Data via Non-Convex Iteratively Reweighted Least Squares",
% NeurIPS 2023, 2023, see also arXiv:2306.04961.

descr = 'LRRS_Gaussian_rank5_obj_tracking_rec';
rng(100) % change to rng('shuffle') to change random seed
%% Choose problem parameters
prob = struct;

prob.n1 = 128; % number of rows
prob.n2 = 40; % number of columns
prob.K1 = 20; % row sparsity of ground truth
prob.r  = 5;  % rank of ground truth
prob.modeX0  = 1; % mode for creation of ground truth
prob.complex = 0; % boolean determining whether ground truth is complex or not
%% Choose sampling scheme
samplemodel = struct;
samplemodel.mode =  'Gaussian_dense';
samplemodel.oversampling = 3.0;
samplemodel = prepare_samplemodel_LRRS(prob,samplemodel);
%% Choose plotting parameters
optsfct = struct;
optsfct.plot = struct;
optsfct.plot.errors             = false;
optsfct.plot.objectives         = true;
optsfct.plot.input              = false;
optsfct.verbose = true;
%% Choose algorithmic parameters
alg_name = {'IRLS-LRRS'};%'SparsePowerFactorization','RiemannianIHT_adap','SparsePowerFactorization','RiemannianIHT_adap','SparsePowerFactorization'};
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
opts.tracking    = 1;
opts.saveiterates = 1;
opts.mode = 'full';


Example = zipExample(descr,prob,samplemodel,optsfct,opts,alg_name);
end

