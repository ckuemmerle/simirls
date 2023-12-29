% This script is used to postprocess and merge experimental data from
% multiple workers.
%% Part 1
successrate_lower=successrate;
paras_experiment_lower=paras_experiment;
parameters_lower = parameters;

%% Part 2
len_upper = length(successrate);
successrate_merged = [successrate_lower,[ones(1,len_upper);successrate;ones(1,len_upper)]];
parameters_merged.m = [parameters_lower.m,parameters.m];
paras_experiment_merged.values=[parameters_lower.m,paras_experiment.values];

successrate = successrate_merged;
parameters = parameters_merged;
paras_experiment = paras_experiment_merged;

%% Part 3
ind_merge = 24;
parameters_merged.m = [parameters.m(1:ind_merge),parameters.m(ind_merge),parameters.m(ind_merge+1:end)];
successrate_merge = [successrate(:,1:ind_merge),0.5*(successrate(:,ind_merge)+successrate(:,ind_merge+1)),successrate(:,ind_merge+1:end)];
ms = parameters_merged.m;
parameters = parameters_merged;
successrate = successrate_merge;