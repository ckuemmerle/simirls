%% Load data for Figure 5a (upper row) 
% This script is loads the experiment data for Figure 5 (upper row) in 
% the paper [1], cf. Appendix.
% Note: The corresponding experiment can be reproduced by using the script
% 'SimIRLS_run_experiment_Figure5a.m'.
% When using this script to load your reproduced experimental data,
% filenames and timestamps below need to be adapted.
%
% Reference:
% [1] Christian Kuemmerle, Johannes Maly, "Recovering Simultaneously 
% Structured Data via Non-Convex Iteratively Reweighted Least Squares",
% NeurIPS 2023, 2023, see also arXiv:2306.04961v2.
clear
ms_all = 40:5:280;
sparsitys=[1,2:2:40];
load('LRRS_m_45_155_LRRS_FourierRank1_rank1_n2_40_Fourier_rank1_K1_1_2023-05-22_0017-59-044','Example')
disp(['Possible measurements: ',num2str(ms_all)])
successrate_matrix = zeros(length(sparsitys),length(ms_all),length(Example.alg_name));
for ii = 1:length(sparsitys)
    exp_part1 = 'LRRS_FourierRank1_rank1_n2_40_Fourier_rank1_';
    exp_part2 = ['K1_',num2str(sparsitys(ii))];
    exp_part3 = '_2023-05-';
    exp=[exp_part1,exp_part2,exp_part3];
    Dir = dir(['**/*',exp,'*.mat']);
    if length(Dir) > 1
        warning('More than one file with file name pattern found...')
    elseif length(Dir) == 0
        successrate = zeros(1,length(ms_all));
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
plot_ms_last = 230;
ind_last = find(ms_plot == plot_ms_last);
ms_plot = ms_plot(1:ind_last);
x = ms_plot;
y = sparsitys;
degs_lrrs = @(t) Example.prob.r*(t+Example.prob.n2-Example.prob.r);
degs_freedom = degs_lrrs(sparsitys);

Example.alg_name_out = get_good_algo_names(Example.alg_name);
for i=1:length(Example.alg_name_out)
    figure;
    successrate_matrix_plot = successrate_matrix(:,1:ind_last,i);
    h = uimagesc(sparsitys,ms_plot,successrate_matrix_plot(:,:)');
    colormap pink
    colorbar
    ax= gca;
    ax.YDir = 'normal';
    title(strcat([Example.alg_name_out{i},', Fourier measurements']),'interpreter','latex');
    hold on;
    plot(fliplr(y),fliplr(degs_freedom),'r-','LineWidth',1);
    xname='Row sparsity $s$';
    yname='Number of measurements $m$';
    hleg = legend({'Degrees of freedom $r\cdot (s + n_2-r)$'},'interpreter','latex','Location','north');
    %% Postprocess figure
    nr_plots = 2;
    plot_options = struct;
    postprocess_fig_LRRS(nr_plots,xname,yname,plot_options);
    set(hleg,'visible','off');
    %% Save file
    filename=strcat('results/experiment_FourierR1Meas_n256_40_rank1_',Example.alg_name{i});
    save_LRRS_plots;
end