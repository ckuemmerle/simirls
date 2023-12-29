function [Xr,outs,opts,alg_name_out] = run_LRJS_algos(y,A,n1,n2,alg_name,opts_custom)
%run_LRJS_algos This function executes algorithms indicated in 'alg_name' 
% for a given low-rank and joint sparse recovery problem, see [1-3] below
% for available algorithms.
% If appropriate, the function also creates separate instances for
% executing an algorithm with different algorithmic parameters indicated by
% 'opts_custom' (e.g., if the corresponding value of a field is an array 
% or cell array containing parameter values)
%
% Inputs:
%               y: (m x 1) measurement vector.
%               A: action of measurement operator (m x (n1*n2)) given as
%                       function handle
%              n1: number of rows in data matrix
%              n2: number of columns in data matrix
%        alg_name: (1 x nr_algos) cell of character strings indicating
%                    which algorithm to use. Available options:
%                   
%     opts_custom: (1 x nr_algos) cell of custom options for the
%                   respective algorithms.
%   
% Outputs:
%              Xr: (1 x length(alg_name_out)) cell array with estimated
%                   ground truth by respective algorithms.
%            outs: (1 x length(alg_name_out)) cell arrray with cells
%                   containing respective algorithmic statistics/quantities 
%            opts: (1 x length(alg_name_out)) cell array whose cells are
%                   structure arrays containing algorithmic options.
%    alg_name_out: (1 x length(alg_name_out)) cell array with character
%                   strings indicating algorithm choice (and potentially 
%                   parameter values, if they vary)
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
% Numerical Algorithms, 93, 669–693 (2023),
% https://doi.org/10.1007/s11075-022-01433-5.

opts_extendnames = {'p','pencil_para','mode_eps','type_mean'};
alg_name_extend = 'IRLS';
[opts_new,alg_name,alg_name_out] = extend_algopts(opts_custom,opts_extendnames,...
    alg_name,alg_name_extend);

nr_algos = length(alg_name); % number of algorithms
opts     = cell(1,nr_algos);
outs=cell(1,nr_algos);

for l=1:nr_algos
    if ~contains(alg_name{l},'IRLS')
        opts{l} = setExtraOpts(opts{l},opts_new{l});
    end
    if strcmp(alg_name{l},'RiemannianIHT_adap') % corresponds to Riemannian IHT with adaptive stepsize as in [3]
       if ~isnumeric(A)
            A = A{1}(eye(n1*n2));
       end
       if isfield(opts{l},'verbose') == false || isempty(opts{l}.verbose)
            opts{l}.verbose = true;
       end
       [Xr{l},outs{l}] = riemannian_adaptive_iht(A,n1,n2,y,opts{l});
   elseif strcmp(alg_name{l},'SparsePowerFactorization') % corresponds to SPF as in [2]
        if isfield(opts{l},'r') == false || isempty(opts{l}.r)
            error('Please specify a rank parameter for SparsePowerFactorization.')
        end
        if ~isnumeric(A)
            A = A{1}(eye(n1*n2));
        end
        if isfield(opts{l},'N0') == false || isempty(opts{l}.N0)
            opts{l}.N0 = 50;
        end
        if isfield(opts{l},'alpha') == false || isempty(opts{l}.alpha)
            opts{l}.alpha = 0.5;
        end
        if isfield(opts{l},'beta') == false || isempty(opts{l}.beta)
            opts{l}.beta = 0.5;
        end
        if isfield(opts{l},'ISTAtolerance') == false || isempty(opts{l}.ISTAtolerance)
            opts{l}.ISTAtolerance = 1e-8;
        end
        if isfield(opts{l},'K1') == false || isempty(opts{l}.K1)
            error('Please specify a column sparsity parameter for SparsePowerFactorization.')
        end
        
        [u0,v0] = StartValue(y,A,n1,n2,opts{l}.r);

        [U,V,outs{l}] = rSPF(A,y,n1,n2,opts{l}.r,opts{l}.K1/n1,...
            1,u0,v0,opts{l}.N0,opts{l});
        Xr{l}=(U*V');       
   elseif contains(alg_name{l},'IRLS-LRRS') % corresponds to IRLS(-LRRS)/Algorithm 1 in [1]
        opts{l} = getDefaultOpts_IRLS;
        opts{l} = setExtraOpts(opts{l},opts_new{l});
        if isfield(opts{l},'K1') == false || isempty(opts{l}.K1)
            opts{l}.K1 = [];
        end
        if isfield(opts{l},'r') == false || isempty(opts{l}.r)
            opts{l}.r = [];
        end
        if isfield(opts{l},'N0') == false || isempty(opts{l}.N0)
            opts{l}.N0 = 50;
        end
        if isfield(opts{l},'pJ') == false || isempty(opts{l}.pJ)
            opts{l}.pJ = 0;     % Non-convexity parameter pJ corresponding to the joint sparsity inducing term
        end
        if isfield(opts{l},'pR') == false || isempty(opts{l}.pR)
            opts{l}.pR = 0;     % Non-convexity parameter pR corresponding to the low-rank inducing term
        end
        if isfield(opts{l},'tol') == false || isempty(opts{l}.tol)
            opts{l}.tol     = 1e-4; % %Tolerance for relative change in Frobenius for convergence (e.g., 1e-4)
        end
        if ~isnumeric(A)
            A = A{1}(eye(n1*n2));
        end
        [Xr{l},outs_algo_c] = ...
        IRLS_LRRS(A,y,n1,n2,opts{l});
        fn = fieldnames(outs_algo_c);
        for i = 1:length(fn)
            outs{l}.(fn{i}) = outs_algo_c.(fn{i});
        end
   end
       
end


end

function opts = setExtraOpts(opts,opts_new)
    if ~isempty(opts_new)
        optNames = fieldnames(opts_new);
        for i = 1:length(optNames)
            optName = optNames{i};
            opts.(optName) = opts_new.(optName);
        end
    end

end

