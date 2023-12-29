% This script is merge experimental data from multiple workers computing 
% results for independent instances.
%% Load first part
avg_error_rel_tmp = avg_error_rel;
error_fro_tmp=error_fro;
error_fro_rel_tmp=error_fro_rel;
success_count_tmp=success_count;
successrate_tmp = successrate;
times_tmp = times;
Ns_tmp = Ns;

%% Merge
avg_error_rel = (avg_error_rel_tmp+ avg_error_rel)/2;
error_fro = cat(2,error_fro_tmp,error_fro);
error_fro_rel = cat(2,error_fro_rel_tmp,error_fro_rel);
success_count = cat(2,success_count_tmp,success_count);
successrate = (successrate+successrate_tmp)/2;
times = cat(2,times_tmp,times);
Ns = cat(2,Ns_tmp,Ns);
instancesize = size(Ns,2);

%% Clean-Up
clear('avg_error_rel_tmp')
clear('error_fro_tmp')
clear('error_fro_rel_tmp')
clear('success_count_tmp')
clear('successrate_tmp')
clear('times_tmp')
clear('Ns_tmp')

%% Plot
plot_results_success_phasetrans(successrate,parameters,alg_name,[],[],...
     ['Success rate of rel. Frobenius error below threshold']);