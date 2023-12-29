function [outs] = run_instances_LRRS(paras_experiment,...
    instancesize,Example)
%run_instances_LRRS This function runs experiments for several instances of
% reconstructions for jointly low-rank and row sparse recovery problems.
%% Unzip problem, sampling and algorithmic parameters
[prob,samplemodel,optsfct,opts,alg_name] = unzipExample(Example);
rng shuffle
%% Set parameters
Example.optsfct.plot = struct;
Example.optsfct.plot.errors             = false;
Example.optsfct.plot.input              = false;

n_jobs = opts.n_jobs;
parasexp_len = length(paras_experiment.values);
opts_extendnames = {'p','mode_eps','type_mean'};
alg_name_extend = 'IRLS';
[~,alg_name,alg_name_out] = extend_algopts(opts,opts_extendnames,...
    alg_name,alg_name_extend);
nr_algos = length(alg_name);
nr_algos_ = max(nr_algos,1);
% verbose = 0;
if nr_algos >= 1
    successratecomp_bool = true;
    success_threshold = 1e-4;
    Ns               = cell(nr_algos,instancesize,parasexp_len);
    times            = cell(nr_algos,instancesize,parasexp_len);
    error_fro_rel    = cell(nr_algos,instancesize,parasexp_len);
    error_fro        = cell(nr_algos,instancesize,parasexp_len);
    successrate      = zeros(nr_algos,parasexp_len);
    avg_error_rel    = zeros(nr_algos,parasexp_len);
else
    successratecomp_bool = false;
    
end

outs         = struct;
outs.samplemodel = cell(1,parasexp_len);
outs_algos   = cell(instancesize,parasexp_len);
outs_problem = cell(instancesize,parasexp_len);
if not(isfield(Example.optsfct,'parallel')) ||  Example.optsfct.parallel
    delete(gcp('nocreate'))
    pc = parcluster;
    % set number of workers
    pc.NumWorkers = min(instancesize,n_jobs);
    % start the parallel pool
    poolobj = parpool(pc, min(instancesize,n_jobs));
end
if successratecomp_bool
    success_count = zeros(nr_algos,instancesize,parasexp_len);
end

disp('Problem setup:')
disp(['Nr. of rows of ground truth matrix: ',num2str(prob.n1)])
disp(['Nr. of columns of ground truth matrix: ',num2str(prob.n2)])
disp(['Type of ground truth: ','(default)'])
if successratecomp_bool
    disp(['Rank of ground truth :',num2str(prob.r)])
    disp(['Group sparsity of ground truth :',num2str(prob.K1)])
end
disp(['Maximal number of elements: ',num2str(prob.n1*prob.n2)])

for l = 1:parasexp_len
    paraname = paras_experiment.name;
    disp(['Run experiment for ',paraname,'=',num2str(paras_experiment.values(l)),'...'])
    if strcmp(paraname,'SNR')
        Example.prob.(paraname) = paras_experiment.values(l);
    elseif strcmp(paraname,'m')
        Example.samplemodel.(paraname) = paras_experiment.values(l);
        Example.samplemodel.oversampling = Example.samplemodel.(paraname)/Example.samplemodel.deg_freedom;
        disp(['Corresponds to an oversampling of ',num2str(Example.samplemodel.oversampling),'.'])
        outs.samplemodel{l} = Example.samplemodel;
    elseif strcmp(paraname,'r')
        prob.r = paras_experiment.values(l);
        Example.opts.rankpara = paras_experiment.values(l);
        m_tmp = Example.samplemodel.m;
        Example.samplemodel = prepare_samplemodel_LRRS(prob,Example.samplemodel);
        Example.samplemodel.m = m_tmp;
        Example.samplemodel.oversampling = Example.samplemodel.m/Example.samplemodel.deg_freedom;
    elseif strcmp(paraname,'K1')
        prob.K1 = paras_experiment.values(l);
        Example.opts.rowspara = paras_experiment.values(l);
        m_tmp = Example.samplemodel.m;
        Example.samplemodel = prepare_samplemodel_LRRS(prob,Example.samplemodel);
        Example.samplemodel.m = m_tmp;
        Example.samplemodel.oversampling = Example.samplemodel.m/Example.samplemodel.deg_freedom;
    else
        samplemodel.(paraname) = paras_experiment.values(l);
        Example.samplemodel = prepare_samplemodel_LRRS(prob,samplemodel);
        disp(['Number of measurements: ',num2str(Example.samplemodel.m)])
        outs.samplemodel{l} = Example.samplemodel;
    end
  
    if not(isfield(Example.optsfct,'parallel')) ||  Example.optsfct.parallel
        parfor kk = 1:instancesize
            [~,outs_c] = run_methods_LRRS(Example);
            if successratecomp_bool
                for ll = 1:nr_algos_
                    Ns{ll,kk,l} = outs_c.outs_methods{ll}.N;
                    times{ll,kk,l} = outs_c.outs_methods{ll}.time(end);
                    error_fro_rel{ll,kk,l} = outs_c.errors.fro_rel{ll};
                    error_fro{ll,kk,l} = outs_c.errors.fro{ll};
                    outs_c.outs_methods{ll}=rmfield(outs_c.outs_methods{ll},'X')
                end
                outs_algos{kk,l} = outs_c.outs_methods;
                outs_tmp = rmfield(outs_c,'outs_methods');
                outs_tmp.sampling = rmfield(outs_tmp.sampling,'Phi');
                outs_tmp.sampling = rmfield(outs_tmp.sampling,'Phihat');
                outs_problem{kk,l} = rmfield(outs_tmp,'X0');
            else
                outs_problem{kk,l} = outs_c;
            end
        end
    else
        for kk = 1:instancesize
            [~,outs_c] = run_methods_LRRS(Example);
            for ll = 1:nr_algos
                Ns{ll,kk,l} = outs_c.outs_methods{ll}.N;
                times{ll,kk,l} = outs_c.outs_methods{ll}.time(end);
                error_fro_rel{ll,kk,l} = outs_c.errors.fro_rel{ll};
                error_fro{ll,kk,l} = outs_c.errors.fro{ll};
            end
            if successratecomp_bool
                outs_algos{kk,l} = outs_c.outs_methods;
                outs_tmp = rmfield(outs_c,'outs_methods');
                outs_tmp.sampling = rmfield(outs_tmp.sampling,'Phi');
                outs_tmp.sampling = rmfield(outs_tmp.sampling,'Phihat');
                outs_problem{kk,l} = outs_tmp;
            else
                outs_problem{kk,l} = outs_c;
            end
        end
    end
    for kk = 1:instancesize
        for ll = 1:nr_algos
            if error_fro_rel{ll,kk,l}(end) < success_threshold
                success_count(ll,kk,l) = 1;
            end
        end
    end
    for ll = 1:nr_algos
        successrate(ll,l) = mean(success_count(ll,:,l));
        avg_error_rel(ll,l) = 0;
        for kk = 1:instancesize
            avg_error_rel(ll,l) = avg_error_rel(ll,l) + error_fro_rel{ll,kk,l}(end);
        end
        avg_error_rel(ll,l) = avg_error_rel(ll,l)./instancesize;
    end
end
if not(isfield(Example.optsfct,'parallel')) ||  Example.optsfct.parallel
    delete(poolobj);
end
outs.outs_problem = outs_problem;
if successratecomp_bool
    outs.outs_algos = outs_algos;
    outs.success_threshold = success_threshold;
    outs.alg_name = alg_name_out;
    outs.Ns = Ns;
    outs.times  = times;
    outs.success_count = success_count;
    outs.successrate = successrate;
    outs.error_fro_rel = error_fro_rel;
    outs.error_fro = error_fro;
    outs.avg_error_rel = avg_error_rel;
else
    error('Check this issue.')
end
outs.nr_algos = nr_algos;
end