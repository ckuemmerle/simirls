%% Load data for Figure 2 (first row)
% This script is loads the experiment data for Figure 2, first row, in the 
% paper [1], cf. Section 4.
% Note: The corresponding experiment can be reproduced by using the script
% 'SimIRLS_run_experiment_Figure2a.m'.
% When using this script to load your reproduced experimental data,
% filenames and timestamps below need to be adapted.
%
% Reference:
% [1] Christian Kuemmerle, Johannes Maly, "Recovering Simultaneously 
% Structured Data via Non-Convex Iteratively Reweighted Least Squares",
% NeurIPS 2023, 2023, see also arXiv:2306.04961v2.
clear
ms_all = [300:25:1000,1050:50:1500,1600:100:2000];
sparsitys=[20:5:60];
load('LRRS_m_300_800_LRRS_Gaussian_rank5_n2_40_Gaussian_dense_base_K1_20_2023-05-16_0642-48-394','Example')
disp(['Possible measurements: ',num2str(ms_all)])
successrate_matrix = zeros(length(sparsitys),length(ms_all),length(Example.alg_name));
for ii = 1:length(sparsitys)
    exp_part1 = 'LRRS_Gaussian_rank5_n2_40_Gaussian_dense_base_';
    exp_part2 = ['K1_',num2str(sparsitys(ii))];
    exp_part3 = '_2023-05-';
    exp=[exp_part1,exp_part2,exp_part3];
    Dir = dir(['**/*',exp,'*.mat']);
    if length(Dir) > 1
        warning('More than one file with file name pattern found...')
    elseif length(Dir) == 0
        successrate = zeros(1,length(ms));
    else
        load(Dir.name,'successrate')
        load(Dir.name,'parameters')
    end
    ms = parameters.m;
    ms_start = min(ms);
    ms_end   = max(ms);
    ind_begin = find(ms_all == ms_start);
    ind_end   = find(ms_all == ms_end);
    inds = [ind_begin:ind_end];
    successrate_matrix(ii,inds,:) = successrate';
    if (inds(end)+1 < length(ms_all))
         successrate_matrix(ii,inds(end)+1:end,:) = 1;
    end
end
%% Plotting
ms_plot = ms_all;
plot_ms_last = 1100;
ind_last = find(ms_plot == plot_ms_last);
ms_plot = ms_plot(1:ind_last);
x = ms_plot;
y = [sparsitys(1)-5,sparsitys,sparsitys(end)+5];
degs_lrrs = @(t) Example.prob.r*(t+Example.prob.n2-Example.prob.r);
degs_freedom = degs_lrrs(y);
Example.alg_name_out = get_good_algo_names(Example.alg_name);
for i=1:length(Example.alg_name_out)
    figure;
    successrate_matrix_plot = successrate_matrix(:,1:ind_last,i);
    h = uimagesc(sparsitys,ms_plot,successrate_matrix_plot(:,:)');
    colormap pink
    colorbar
    ax= gca;
    ax.YDir = 'normal';
    title(strcat([Example.alg_name_out{i},', Gaussian measurements']),'interpreter','latex');
    hold on;
    plot(fliplr(y),fliplr(degs_freedom),'r-','LineWidth',1);
    
    xname='Row sparsity $s$';
    yname='Number of measurements $m$';
    %% Postprocess figure
    nr_plots = 2;
    plot_options = struct;
    postprocess_fig_LRRS(nr_plots,xname,yname,plot_options);
    %% Save file
    filename=strcat('results/experiment_Gauss_n256_40_rank5_base_',Example.alg_name{i});
    save_LRRS_plots;
end