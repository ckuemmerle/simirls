% This script runs algorithmic recovery experiments for any number of 
% measurements in 'ms' for a row sparsity value compatible with the 
% sparsity provided by the i-th value in 'sparsity'. Finally, the results 
% are saved and plotted.
[meas,degs] = compute_measurements_LRRS_sparsitys(Example,sparsitys,ms,...
    rho_min,rho_max);
paras_experiment = struct;
paras_experiment.name = 'm';
paras_experiment.values = meas{i};

Example.prob.K1=sparsitys(i);
disp(['Run experiment with row-sparsity of ',num2str(Example.prob.K1)])
if exist('parallelflag')
    Example.optsfct.parallel = parallelflag;
else
    Example.optsfct.parallel = true;
end
Example.opts.K1    = floor(K1_misspecfication_fac*Example.prob.K1);
Example.opts.r     = floor(r_misspecfication_fac*Example.prob.r);
Example.opts.N0          = 200;
Example.opts.verbose     = 1;
Example.optsfct.verbose  = false;
Example.samplemodel = prepare_samplemodel_LRRS(Example.prob,Example.samplemodel);
option = [];
filename_note={'prob','K1'};
resultname = 'successrate';
resulttext = 'Success rate of rel. Frobenius error below threshold';
wrapper_experiment_LRRS(Example,...
    paras_experiment,instancesize,resultname,resulttext,option,filename_note);