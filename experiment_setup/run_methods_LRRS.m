function [Xr,outs] = run_methods_LRRS(Example)
%run_methods_LRRS This function executes algorithms for low-rank and row-
% sparse matrix recovery in the setting provided by 'Example'. 
[prob,samplemodel,optsfct,opts,alg_name] = unzipExample(Example);
nr_algos = length(alg_name);
if nr_algos == 0
    runalgos_bool = false;
else
    runalgos_bool = true;
end
outs = struct;

if isfield(optsfct,'plot') && strcmp(optsfct.plot,'all')
    optsfct.plot.input = 1;
    optsfct.plot.errors = 1;
end
if not(isfield(optsfct,'verbose'))
    optsfct.verbose = false;
end
if not(isfield(prob,'cond_nr'))
    prob.cond_nr = 5;
end
[U,Sigma,V,T0] = sampling_X_jointsparselowrank(prob.n1,prob.n2, ...
    prob.K1,prob.r,prob.modeX0,prob.complex,prob.n2,prob.cond_nr);
X0 = U*Sigma*V';
X0 = (X0/norm(X0,'fro'));

%% Create sampling operator
sampling = sample_MatrixRecovery(prob.n1,prob.n2,samplemodel);
if optsfct.verbose
    fprintf(['Total number of samples m=: ',num2str(sampling.m),'\n'])
end
%% Compute incoherences, if applicable
if isfield(opts,'rankpara')
    r = opts.rankpara;
else
    r = n;
end

outs.X0  = X0;
outs.U = U;
outs.V = V;
outs.Sigma = Sigma./norm(X0,'fro');
outs.T0 = T0;

if isfield(optsfct,'plot') && isfield(optsfct.plot,'input') && optsfct.plot.input
    optsplot = struct;
    outs.figgroundtruth =  figure;
    imagesc(abs(X0));
    colormap('hot');    
    colorbar
    title('Sparsity pattern of ground truth $X_0$','Interpreter','latex')
    xlabel('Column index')
    ylabel('Row index')
end
%% Prepare input vector
X_vec = reshape(X0,[prob.n2*prob.n1,1]);
Y = sampling.Phi*X_vec;
if isfield(prob,'add_noise') && prob.add_noise
    SNR = prob.SNR;
    sigma = sqrt(sum(Y.^2)./(length(Y)*SNR));
    w = sigma.*randn(length(Y),1);
    y = Y + w;
else
    y = Y;
end
outs.y  = y;
%% Run recovery methods
if runalgos_bool
    A = @(Xvec) sampling.Phi*Xvec; 
    Atild = @(Xvec) sampling.Phihat*Xvec;
    [Xr,outs_methods,opts,alg_name] = run_LRJS_algos(outs.y,{A,Atild},prob.n1,prob.n2,alg_name,opts);
%% Compute errors
    outs.errors = ...
    error_general_LRJS(outs.X0,opts,outs_methods,alg_name);

%% Plot different pieces of information
    if isfield(optsfct,'plot') && isfield(optsfct.plot,'errors') && optsfct.plot.errors
        visualize_errorcurves_combined(outs.errors.fro_rel,alg_name,'titlestring','Relative Frobenius error on graph shift matrix A vs. iteration count');
    end
    if isfield(optsfct,'plot') && isfield(optsfct.plot,'objectives') && optsfct.plot.objectives
        if contains(alg_name{1},'IRLS')
            alg_name_  = cell(1,4);
            alg_name_{1} = 'Rank Objective $\sqrt{\mathcal{F}_{lr,\varepsilon_k}(\mathbf{X}^{(k)})}$';
            alg_name_{2} = 'Sparsity Objective $\sqrt{\mathcal{F}_{sp,\delta_k}(\mathbf{X}^{(k)})}$';
            alg_name_{3} = 'IRLS Objective $\sqrt{\mathcal{F}_{\varepsilon_k,\delta_k}(\mathbf{X}^{(k)})}$';
            alg_name_{4} = 'Rel. Frob. error $\|\mathbf{X}^{(k)} - \mathbf{X}_\star\|_F/\|\mathbf{X}_\star\|_F$';
            rankobj = outs_methods{1}.rankobj_after_eps; 
            sparsobj = outs_methods{1}.sparsobj_after_eps;
            visualize_errorcurves_combined({sqrt(rankobj),sqrt(sparsobj),sqrt(outs_methods{1}.obj_after_eps),outs.errors.fro_rel{1}}, ...
                alg_name_,'plottype','semilogy','ylabelstring',[],'titlestring',[]);
            outs.objfigure = gcf;
        end
    end

    outs.outs_methods = outs_methods;
    outs.sampling = sampling;
else
    yr = [];
end
outs.opts = opts;
outs.alg_name = alg_name;
end