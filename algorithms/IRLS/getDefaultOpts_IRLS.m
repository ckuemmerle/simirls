function opts = getDefaultOpts_IRLS
% Provides default parameters for IRLS as used in [1].
%
% References:
% [1] Christian Kuemmerle, Johannes Maly, "Recovering Simultaneously 
% Structured Data via Non-Convex Iteratively Reweighted Least Squares",
% NeurIPS 2023, 2023, see also arXiv:2306.04961.
% [2] Christian Kuemmerle and Claudio Mayrink Verdun, "A scalable second 
% order method for ill-conditioned matrix completion from few samples", 
% ICML 2021, 2021,
% http://proceedings.mlr.press/v139/kummerle21a/kummerle21a-supp.pdf.
% [3] Wen Huang, Pierre-Antoine Absil and Kyle A. Gallivan, "Intrinsic 
% representation of tangent vectors and vector transports on matrix 
% manifolds", Numerische Mathematik, 136(2): 523–543, 2017.

opts.pR             = 0;  % Non-convexity parameter for low-rank inducing term.
                          % If 0 < p <= 1: Schatten-p quasi-norm
                          % If p = 0: Log-determinant objective (used in
                          % [1-2])
opts.pJ             = 0;  % Non-convexity parameter for row-sparsity inducing
                          % term.
                          % If 0 < p <= 1: l_{2,q} quasi-norm
                          % If p = 0: Sum-of-logarithms of row l2-norms 
                          % (used in [2]).
opts.N0             = 200;  % max. number of outer iterations (second order method like IRLS)
opts.N0_inner       = 50;   % max. number of inner iterations (if iterative solver is used for weighted least squares)
opts.N0_firstorder  = 5000; % max. number of iteration for a first order method
opts.N_SVD          = 20;   % max. number of iterations for power method-type solver for partial SVD (such as bksvd)
opts.tol            = 1e-9;  % stopping criterion, lower bound on relative change of Frobenius norm
opts.tol_CG         = 1e-5;  % tolerance for iterative solver for weighted least squares (e.g., conjugate gradients)
opts.epsmin         = 1e-14;  % minimal value for epsilon smoothing
opts.use_min        = 1; % if true, force smoothing parameter updates to be non-increasing (as in [1-2])
opts.type_mean      = 'optimal'; % use optimal mean (geometric mean for p=0) as in [1-2].
opts.symmetricflag  = false;
opts.objective      = 'objective_thesis'; % Determines type of objective smoothing, cf. get_rankobjective.m.
opts.epschoice      = 'independent';
opts.complex        = 0;
opts.tracking       = 0; % If true: objective values (also broken down into
                         % row-sparsity part and low-rank promoting part) 
                         % are tracked across iterations and returned via 
                         % 'outs'.
                         % If false: No computation of objective values
                         % (can be much faster if implemented correctly).
if isfield(opts,'tracking')
opts.verbose        = 1; 
opts.tangent_para   = 'extrinsic'; % decides what kind of computational 
                       % representation of the tangent space is used: 
                       % 'intrinsic' or 'extrinsic'. 
                       % 'Extrinsic' used in the implementations of [1] and
                       % [2] in practice, 'intrinsic' has theoretical
                       % advantages, see also [3].
opts.mu             = 0; % corresponds to hyper-parameter relaxing the
                         % linear measurement constrained to l2-error term
                         % if > 0. For "=0", corresponds to hard linear
                         % measurement constraints (currently only =0
                         % supported in IRLS implementation - can be easily
                         % generalized).
end

    