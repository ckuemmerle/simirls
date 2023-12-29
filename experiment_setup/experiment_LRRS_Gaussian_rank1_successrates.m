function experiment_LRRS_Gaussian_rank1_successrates(i,ms_vec,sparsitys,...
    rho_min,rho_max,min_max_meas,varargin)
% This function sets up the experiment for a particular set of number of
% measurements comparing IRLS, RiemAdaIHT and SPF for example
% 'LRRS_Gaussian_rank1_n2_40'.
Examples   = LoadExampleDefinitions;
Params.ExampleName = 'LRRS_Gaussian_rank1_n2_40';
ExampleIdx = SelectExample(Params,Examples);
Example    = Examples{ExampleIdx};
%% Choose algorithmic parameters
[meas,~] = compute_measurements_LRRS_sparsitys(Example,sparsitys,ms_vec,...
    rho_min,rho_max);
paras_experiment = struct;
paras_experiment.name = 'm';
paras_experiment.values = meas{i};

instancesize = 64;
Example.opts.n_jobs = 32;
Example.prob.K1=sparsitys(i);
disp(['Run experiment with row-sparsity of ',num2str(Example.prob.K1)])
Example.optsfct.parallel = true;
Example.opts.K1    = Example.prob.K1;
Example.opts.N0          = 200;
Example.opts.verbose     = 1;
Example.optsfct.verbose  = false;
Example.alg_name = {'IRLS-LRRS','RiemannianIHT_adap','SparsePowerFactorization'};
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
Example.samplemodel = prepare_samplemodel_LRRS(Example.prob,Example.samplemodel);
option = [];
filename_note={'prob','K1'};
resultname = 'successrate';
resulttext = 'Success rate of rel. Frobenius error below threshold';
wrapper_experiment_LRRS(Example,...
    paras_experiment,instancesize,resultname,resulttext,option,filename_note);
end