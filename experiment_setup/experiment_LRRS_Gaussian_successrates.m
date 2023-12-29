function experiment_LRRS_Gaussian_successrates(i,ms_vec,ranks,...
    rho_min,rho_max,min_max_meas,varargin)
% This function sets up the experiment for a particular set of number of
% measurements comparing IRLS, RiemAdaIHT and SPF for example
% 'LRRS_Gaussian_phasetransition'.
Examples   = LoadExampleDefinitions;
Params.ExampleName = 'LRRS_Gaussian_phasetransition';
ExampleIdx = SelectExample(Params,Examples);
Example    = Examples{ExampleIdx};
%% Choose algorithmic parameters
[meas,~] = compute_measurements_LRRS(Example,ranks,ms_vec,...
    rho_min,rho_max);
paras_experiment = struct;
paras_experiment.name = 'm';
paras_experiment.values = meas{i};

instancesize = 8;
Example.opts.n_jobs = 8;
Example.prob.r=ranks(i);
disp(['Use graphmodel with rank cutoff at ',num2str(Example.prob.r)])
Example.optsfct.parallel = true;
Example.opts.rankpara    = Example.prob.r;
Example.opts.N0          = 100;
Example.opts.verbose     = false;
Example.opts.tol         = 1e-6;
Example.optsfct.verbose  = false;
Example.alg_name = {'RiemannianIHT_adap','SparsePowerFactorization','IRLS-LRRS'};
if nargin > 6   
    changesstruc = varargin{1};
    names1 = fieldnames(changesstruc);
    nrfields = length(names1);
    for l = 1:nrfields
        if isstruct(changesstruc.(names1{l}))
            names2 = fieldnames(changesstruc.(names1{l}));
            for ll = 1:length(names2)
                Example.(names1{l}).(names2{ll}) = changesstruc.(names1{l}).(names2{ll});
            end
        else
            Example.(names1{l}) = changesstruc.(names1{l});
        end
    end
end
option = [];
filename_note={'prob','r'};
resultname = 'successrate';
resulttext = 'Success rate of rel. Frobenius error below threshold';
wrapper_experiment_LRRS(Example,...
    paras_experiment,instancesize,resultname,resulttext,option,filename_note);
end