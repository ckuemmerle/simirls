%% Load data for Figure 7
% This script is loads the experiment data for Figure 7, in the appendix of
% the paper [1], cf. Section 4.
% Note: The corresponding experiment can be reproduced by using the script
% 'SimIRLS_run_experiment_Figure7_rank1_robustness_noise.m'.
% When using this script to load your reproduced experimental data,
% filenames and timestamps below need to be adapted.
%
% Reference:
% [1] Christian Kuemmerle, Johannes Maly, "Recovering Simultaneously 
% Structured Data via Non-Convex Iteratively Reweighted Least Squares",
% NeurIPS 2023, 2023, see also arXiv:2306.04961v2.
load('LRRS_SNR_0.1_1e+16_LRRS_Gaussian_rank1_noisy_n2_40_Gaussian_dense_r_1_2023-08-09_2322-30-824.mat')
nr_algos = length(alg_name);
nr_parameters =  length(parameters.SNR);
szvec = size(error_fro_rel);
instancesize = szvec(2);

ErrFroRel_plot = cell(nr_algos,nr_parameters);
Median_ErrFroRel = cell(nr_algos,nr_parameters);
for i=1:nr_algos
    for j=1:nr_parameters
        ErrFroRel_plot{i,j} = zeros(1,instancesize);
        for k=1:instancesize
            ErrFroRel_plot{i,j}(k)= error_fro_rel{i,k,j}(end);
        end
    end
end
Median_ErrFroRel = get_median_errors(ErrFroRel_plot);
%%
options = struct;
options.logy = true;
options.logx = true;
options.linewidth = 4;
options.capsizefac = 4;
markerfac = 0.1;
custom_options = struct;
custom_options.markersize = markerfac.*ones(1,length(alg_name));
custom_options.markers = {'-x', '--d','-.v','-x',  '-.d',  '-o'};
custom_options.ColorOrderIndices = [1,3,5];
figure_names = struct;
figure_names.xname = 'Number of measurements $m$';
figure_names.yname = 'relative Frobenius reconstruction error $\|\hat{X}-X_0\|_{F}/\|X_0\|_{F}$';
figure_names.titlestr = 'Experiment with n=50, r=2, complex domain, Gaussian noise';
startind = 3;
finalind = 14;
options.xlim = [parameters.SNR(startind),parameters.SNR(finalind)];
parameters_ = parameters;
parameters_.SNR = parameters.SNR(startind:finalind);
plot_results_errorbar(Median_ErrFroRel(:,startind:finalind),ErrFroRel_plot(:,startind:finalind),parameters_,alg_name,options,...
    figure_names,custom_options);
%% Create plot files
axc= gca;
axc.Title.String = '';
filename=strcat('experiments/LRRS_Figure7_noisy_Gaussian');
save_LRRS_plots;