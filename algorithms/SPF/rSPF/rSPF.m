function [U,V,outs] = rSPF(A,y,n1,n2,r,s1,s2,U0,V0,N0,opts)
%rSPF This implements rank-r Sparse Power Factorization with Hard
% Thresholding Pursuit (rSPF_HTP/ Algorithm 4) of [1] for the recovery of
% simultaneously low-rank and row-sparse matrices.
%
% Reference:
% [1] Kiryung Lee, Yihong Wu, and Yoram Bresler. Near-optimal compressed 
% sensing of a class of sparse low-rank matrices via sparse power 
% factorization. IEEE Transactions on Information Theory, 64(3):1666–1698,
% 2018, https://doi.org/10.1109/TIT.2017.2784479.

U = U0;
V = V0;
if isfield(opts,'saveiterates')  && ~isempty(opts.saveiterates) 
    saveiterates = opts.saveiterates;
else
    saveiterates = false;
end
if isfield(opts,'verbose')  && ~isempty(opts.verbose) 
    verbose = opts.verbose;
else
    verbose = true;
end
if isfield(opts,'N0_inner')  && ~isempty(opts.N0_inner) 
    N0_inner = opts.N0_inner;
else
    N0_inner = 100;
end
time = zeros(1,N0);
if saveiterates
    Uout=cell(1,N0);
    Vout=cell(1,N0);
end
tol = opts.tol;
residuals = [];
t=1;
tic;
while t <= N0
    if t > 1
        U_prev = U;
        V_prev = V;
    end
     V = orth(V);
    F = getFr(A,V);
    
    if s1*n1 < n1

        U = B_HTP(F,conj(y),floor(s1*n1),n1,r,N0_inner);

    else

        U = LeastSquares(F,conj(y),1:n1,n1,r);

    end
     U = orth(U);
    G = getGr(A,U);
%     G = conj(G);
    if s2*n2 < n2

        V = B_HTP(G,y,floor(s2*n2),n2,r,N0_inner);

    else

        V = LeastSquares(G,y,1:n2,n2,r);

    end
%     V= conj(V);
    time(t) = toc;
    if t > 1 && norm(U_prev-U) < tol && norm(V_prev-V) < tol
        if saveiterates
            Uout{t}=U;
            Vout{t}=V;
        end
        N0 = t;
    else
        if saveiterates
            Uout{t}=U;
            Vout{t}=V;
        end
    end
    if verbose > 1 || (verbose == 1 && (t == 1 || t == N0))
        res_c = norm(G*V(:)-conj(y));
        residuals = [residuals,res_c];
        fprintf('Iteration: %i,\t Residual norm: %d \n',t,res_c);
    end
    t = t+1;
end
outs = struct;
if saveiterates
    outs.Uout           = Uout(1:N0);
    outs.Vout           = Vout(1:N0);
    outs.X              = cell(1,N0);
    for t = 1:N0
        outs.X{t}       = Uout{t}*Vout{t}';
    end
else
    outs.Uout = U;
    outs.Vout = V;
    outs.X = U*V';
end
outs.N = N0;
outs.time = time(1:N0);
outs.residuals = residuals;
end

