function [X_c,outs] = IRLS_LRRS(Phi,Y,n1,n2,opts)
% Implements Iteratively Reweigthed Least Squares for the recovery of 
% simultaneously low-rank and row-sparse matrices (IRLS-LRRS) 
% from linear observations as studied in [1].
%
% Reference:
% [1] Christian Kuemmerle, Johannes Maly, "Recovering Simultaneously 
% Structured Data via Non-Convex Iteratively Reweighted Least Squares",
% NeurIPS 2023, 2023, see also arXiv:2306.04961.
%
%   Input:  Phi: Linear operator with m rows acting on the matrix space
%                 (n1 x n2), provided as (m x n1*n2) matrix (Here, we do
%                 not make use of any structure in the measurements to
%                 accelerate computations, albeit that is possible).
%             Y: vector corresponding to measurement data
%            n1: number of rows of matrix
%            n2: number of columns of matrix
%          opts: struct with algorithmic options, including also the model 
%                 orders K1 and r
%  Output:  X_c: Estimated matrix of size (n1 x n2)
%          outs: struct with information reporting on algorithmic progress
%                across iterations.
%% Read options
m       = length(Y);  % Number of measurements
K       = opts.K1;    % (Upper) estimate for row sparsity of X
r       = opts.r;     % (Upper) estimate for rank of X
N0      = opts.N0;    % Maximal number of iterations for the IRLS algorithm
pJ      = opts.pJ;    % Non-convexity parameter pJ corresponding to the 
%                       joint-sparsity inducing term, corresponding to 
%                       l_{2,p} quasinorm for p > 0 and to sum of
%                       logarithms of row l2-norms for p = 0 (In [1], we
%                       use p=0 exclusively).
pR      = opts.pR;    % Non-convexity parameter pR corresponding to the 
%                       low-rank inducing part of the objective. For p > 0,
%                       corresponds to Schatten-p quasinorm and for p = 0,
%                       corresponds to logdet objective (In [1], we use p=0
%                       exclusively).
tol     = opts.tol;   % Tolerance for relative change in Frobenius for convergence (e.g., 1e-6).
mode    = opts.mode;  % Determines the manner in which the resulting 
%                       weighted least squares problem of IRLS-LRRS is solved.
%                       Currently: Only 'full' is supported.
verbose = opts.verbose; % Regulates text output
% if 'saveiterates' is true, all iterates are saved and returned via
% 'outs'.
if isfield(opts,'saveiterates') && ~isempty(opts.saveiterates)    
    saveiterates = opts.saveiterates;
else
    saveiterates = false;
end
n_min   = min(n1,n2);
n_max   = max(n1,n2);
mu      = opts.mu;
% if 'tracking' is true, objective values (also broken down int
% row-sparsity part and low-rank promoting part) are tracked across
% iterations and returned via 'outs'.
if isfield(opts,'tracking')
    tracking = opts.tracking;
else
    tracking = false;
end
epsmin = opts.epsmin; % minimal value of smoothing parameters due to numerical precision.
% Choose optimal mean type in definition of weight operator:
if pR == 0
    type_mean = 'geometric';
    qmean_para = [];
else
    type_mean = 'qmean';
    qmean_para = pR/(pR-2);
end
tangent_para = 'extrinsic';

%% Preallocate some space
X           = cell(1,N0);
U_X         = cell(1,N0);
deltas      = zeros(1,N0);
epsilons    = zeros(1,N0);
time        = zeros(1,N0);
lambdas     = zeros(1,N0);
W_1_inv_small= cell(1,N0);
sing        = cell(1,N0);
if tracking
    rankobj_before_eps  = zeros(1,N0);
    rankobj_after_eps   = zeros(1,N0);
    sparsobj_before_eps = zeros(1,N0);
    sparsobj_after_eps  = zeros(1,N0);
    obj_before_eps      = zeros(1,N0);
    obj_after_eps       = zeros(1,N0);
end
%% Iteration of the Algorithm
k=1;
first_iterate = true;
eps_c = Inf;
delta_c = Inf;
W_1_diag_c = ones(n1*n2,1);
W_1_inv_diag_c = ones(n1*n2,1);
W_1_small_c = ones(n1,1);
W_1_inv_small_c = ones(n1,1);
outs = struct;

speedflag = 'fast';

tic
X_vec_c = zeros(n1*n2,1);
singularMatrixCount = 0;
while k <= N0
   %% Iteration of the Algorithm
    if k > 1
        X_c_previous = X_c;
        first_iterate = false;
    end
    if mod(k,50) == 0 
        disp(['Begin Iteration ',num2str(k),'...']);
    end
    eps_prev = eps_c;
    delta_prev = delta_c;
    %% Solve weighted least squares
    if first_iterate % solve (unweighted) least squares problem in first iteration
        Z_vec = (Phi*Phi')\Y;
        X_vec_c = Phi'*Z_vec;
        N_inner_c = 0;
        relres_c = 0;
        lambda_previous = 1;
    else
        lambda_previous = lambda;
        if strcmp(speedflag,'fast')
            [Hsmall,dHsmall] = weight_op_lowrank_prec(weight_op.U, ...
                weight_op.V,weight_op.S_c,1,1,type_mean,0,[],[],qmean_para);
            dHsmall{1}=dHsmall{1}(1:r_c);
            fac = W_1_inv_eps;
            weight_vec_c = get_weight_vec(n1,n2,Hsmall,dHsmall,tangent_para,weight_op,0);
            Vmat = compute_Vmat_LRRS(Phi,W_1_diag_c.*W_1_inv_eps,lambda,weight_op,n1,n2,fac);
            
            [C] = compute_Cmat_LRRS(Phi,W_1_small_c,W_1_diag_c,lambda,weight_op,weight_vec_c,n1,n2,fac);
            Umat = Vmat';
            Bmatvec = (W_1_inv_eps.*(lambda./weight_op.S_c_eps+W_1_diag_c)).^(-1);
            Amat = Phi*(Bmatvec.*Phi');
            if C(end,end) == 0
                X_vec_c = X_c_previous;
                N0 = k;
            else
                lastwarn('', '');
                CinvVmat = C\Vmat;
                [warnMsg, warnId] = lastwarn();
                if not(isempty(warnId))
                    singularMatrixCount = singularMatrixCount + 1;
%                           
                end
                UCinvV = Umat*CinvVmat;
                GoodMat=Amat-UCinvV;
                z = GoodMat\Y;
                Phiz = Phi'*z;
                tmp = Bmatvec.*Phiz;

                CinvVmatz= C\(Vmat*z);
             
                tmp2 = (Bmatvec).*reshape(tangspace_to_matrixspace(CinvVmatz,weight_op),n1*n2,1);
                X_vec_c = tmp-tmp2;
            end
        end
        
        N_inner_c = 0;
        relres_c = 0;
    end
    X_c = reshape(X_vec_c,[n1 n2]); % solution of weighted least squares problem
    %% Update smoothing parameters epsilon and delta
    X_rowsums_c = sqrt(sum(X_c.^2,2));
    [rearr_X_c,~] = sort(X_rowsums_c,'descend');
    X_c_allrows = X_c;
    [s_c,~,~]=update_sparspara(X_rowsums_c,rearr_X_c(K+1),n1);
    [U_X_c,singval,V_X_c] = svd(X_c);

    sing_c=diag(singval);

    if strcmp(opts.epschoice,'coupled')
        delta_c = max(min(delta_c,max(rearr_X_c(K+1),sing_c(r+1)/sqrt(lambda))),epsmin);
        eps_c = sqrt(lambda)*delta_c;
    elseif strcmp(opts.epschoice,'independent')
        delta_prev = delta_c;
        eps_prev = eps_c;
        delta_c = max(min(delta_c,rearr_X_c(K+1)),epsmin);
        eps_c = max(min(eps_c,sing_c(r+1)),epsmin);
        lambda = (eps_c/delta_c)^2; % 
    elseif strcmp(opts.epschoice,'sum_coupled')
        delta_tilde_c_m1 = delta_tilde_c;
        eps_tilde_c_m1 = eps_tilde_c;
        delta_tilde_c = max(min(delta_tilde_c,rearr_X_c(K+1)),epsmin);
        eps_tilde_c = max(min(eps_tilde_c,sing_c(r+1)),epsmin);
        delta_c = 0.5*(delta_tilde_c+ eps_tilde_c*delta_tilde_c_m1/eps_tilde_c_m1);
        eps_c = delta_c* eps_tilde_c_m1/delta_tilde_c_m1;
        lambda = (eps_c/delta_c)^2; % 
    end
    %% Update weight operators
    [S_c,S_c_eps] = set_weight_infovec(sing_c,eps_c,pR,'objective_thesis');
    r_c = length(find(sing_c>eps_c+epsmin));
    weight_op.U = U_X_c(:,1:r_c);
    weight_op.V = V_X_c(:,1:r_c);
    weight_op.S_c = S_c(1:r_c);
    weight_op.S_c_eps = S_c_eps;
    if (k >= 2 && k <= N0 && norm(X_c-X_c_previous,'fro')/norm(X_c,'fro') < tol) || delta_c == epsmin ...
            || singularMatrixCount >= 1
        N0 = k;
    end
    if verbose > 1 || (verbose == 1 && (k ==1 || k == N0))
        fprintf(['%-4s k: %2d N_inner: %2d relres: %.3e delta: %.3e sing_c_r+1: %.3e eps: %.3e r_k: %1d s_k: %1d rearr_X_c: %.3e lambda: %.3e\n'], ...
                mode,k,N_inner_c,relres_c,delta_c,sing_c(r+1),eps_c,r_c,s_c,rearr_X_c(K+1),lambda)
    end
    lambdas(k) = lambda;
    outs.s_largest(k) = s_c;
    outs.r_largest(k) = r_c;
    for i=n_min+1:n_max
       S_c(i)=S_c_eps;
    end
    W_1_inv_eps = delta_c^(2-pJ);
    for i=1:n1 
        W_1_small_c(i) = max(X_rowsums_c(i),delta_c)^(pJ-2);
        W_1_inv_small_c(i) = max(X_rowsums_c(i),delta_c)^(2-pJ);
        for j=1:n2
            W_1_inv_diag_c(i+(j-1)*n1,1) = max(X_rowsums_c(i),delta_c)^(2-pJ);
            W_1_diag_c(i+(j-1)*n1,1) =  max(X_rowsums_c(i),delta_c)^(pJ-2);
        end
    end
    %% Track objective values (if applicable)
    if tracking
        [~,singval_allrows,~] = svd(X_c_allrows,'econ');
        sings = diag(singval_allrows);
        rankobj_before_eps(k) = eps_prev.^(2).*(get_rankobjective(sings,eps_prev,pR,'objective_thesis')...
            -log(eps_prev).*n_min+n_min/2);
        rankobj_after_eps(k) = eps_c.^(2).*(get_rankobjective(sings,eps_c,pR,'objective_thesis')...
            -log(eps_c).*n_min+n_min/2);
        sparsobj_before_eps(k)  = delta_prev.^(2).*(get_rankobjective(rearr_X_c,delta_prev,pJ,'objective_thesis')...
            -log(delta_prev).*n_min+n_min/2);
        sparsobj_after_eps(k)  = delta_c.^(2).*(get_rankobjective(rearr_X_c,delta_c,pJ,'objective_thesis')...
            -log(delta_c).*n_min+n_min/2);
        if mu == 0
            obj_before_eps(k) = rankobj_before_eps(k)+ ...
                sparsobj_before_eps(k);
            obj_after_eps(k) = rankobj_after_eps(k)+ ...
                sparsobj_after_eps(k);
        else
            obj_before_eps(k) = mu*(lambda_previous * rankobj_before_eps(k)+ ...
                sparsobj_before_eps(k)) + 0.5.*sum((Phi*X_c_allrows(:)-Y).^2);
            obj_after_eps(k) = mu*(lambda * rankobj_after_eps(k)+ ...
                sparsobj_after_eps(k)) + 0.5.*sum((Phi*X_c_allrows(:)-Y).^2);
        end
    end
    if saveiterates
        X{k}=X_c;
        W_1_inv_small{k}=W_1_inv_small_c;
        sing{k} = sing_c;
    end
    deltas(k)=delta_c;
    epsilons(k)=eps_c;
    time(k) = toc;
    k=k+1;
end
%% Tidy up the size of the relevant matrices
if tracking
    outs.rankobj_before_eps = rankobj_before_eps(1:N0);
    outs.rankobj_after_eps = rankobj_after_eps(1:N0);
    outs.sparsobj_before_eps = sparsobj_before_eps(1:N0);
    outs.sparsobj_after_eps = sparsobj_after_eps(1:N0);
    outs.obj_before_eps = obj_before_eps(1:N0);
    outs.obj_after_eps = obj_after_eps(1:N0);
end
outs.time  = time(1:N0);
if saveiterates
    outs.X      = X(1:N0);
    outs.sing    = sing(1:N0);
    outs.W_1_inv_small = W_1_inv_small(1:N0);
else
    outs.X      = X_c;
    outs.sing   = sing_c;
    outs.W_1_inv_small = W_1_inv_small_c;
end
outs.deltas     = deltas(1,1:N0);
outs.epsilons   = epsilons(1,1:N0);
outs.lambdas    = lambdas(1:N0);
outs.N          = N0;
outs.s_largest  = outs.s_largest(1:N0);
end