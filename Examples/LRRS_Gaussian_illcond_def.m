function Example = LRRS_Gaussian_illcond_def()
%LRRS_Gaussian_illcond_def This function defines the problem
% parameters of a simple experiment for low-rank and row-sparse matrix
% recovery from dense Gaussian measurements. Unlike in other experimental
% setups, the ground truth is ill-conditioned.
descr = 'LRRS_Gaussian_illcond';
%% Choose problem parameters
prob = struct;
rng('shuffle')

prob.n1 = 128; % number of rows
prob.n2 = 40; % number of columns
prob.K1 = 20; % row sparsity of ground truth
prob.r  = 5;  % rank of ground truth
prob.modeX0  = 'condition_control_log'; % mode for creation of ground truth
prob.cond_nr = 1e5;
prob.complex = 0; % boolean determining whether ground truth is complex or not
%% Choose sampling scheme
samplemodel = struct; 
samplemodel.mode =  'Gaussian_dense';
samplemodel.oversampling = 1.7;
samplemodel = prepare_samplemodel_LRRS(prob,samplemodel);
%% Choose plotting parameters
optsfct = struct;
optsfct.plot = struct;
optsfct.plot.errors     = false; 
optsfct.plot.input      = false;
optsfct.verbose         = true;
%% Choose algorithmic parameters
alg_name = {'IRLS-LRRS','SparsePowerFactorization','RiemannianIHT_adap'};
opts = struct;
opts.rankpara      = prob.r; % rank parameter used as an input for reconstruction algorithm. Should be equal to the rank of ground truth for best results.
opts.rowspara      = prob.K1; % sparsity parameter for group sparsity used as input for reconstruction algorithm.
opts.verbose       = 1;
opts.K1          = floor(prob.K1);
opts.r           = floor(prob.r);
opts.N0          = 250; % max. number of outer IRLS iterations
opts.N0_inner    = 100; % max. number of inner IRLS iterations in algorithm
opts.N0_firstorder = 2000;
opts.tol_CG      = 1e-13;
opts.tol         = 1e-8;
opts.mu          = 0;
opts.saveiterates = 0;
opts.mode = 'full';

Example = zipExample(descr,prob,samplemodel,optsfct,opts,alg_name);
end

