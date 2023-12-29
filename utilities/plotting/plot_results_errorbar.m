function plot_results_errorbar(values_y,values_y_all,parameters,alg_names,...
    options,figure_names,varargin)
% Plots values with error bars based on 25% and 75% quantiles.
markers = {'-x', '-+', '-*', '-o','-x', '-s', '-d', '-^', '-v', ...
           '-x', '-+', '-*', '-o','-x', '-s', '-d', '-^', '-v'};
       
if nargin >= 5
    custom_options = varargin{1};
    if isfield(custom_options,'markers')
        markers =  custom_options.markers;
    end
    if isfield(custom_options,'ColorOrderIndices')
        ColorOrderIndices =  custom_options.ColorOrderIndices;
    end
    if isfield(custom_options,'which_algos')
        which_algos = custom_options.which_algos;
        nr_algos_used = length(which_algos);
        select_algos = 1;
    else
        select_algos = 0;
    end
end
if not(isfield(options,'linewidth'))
    options.linewidth = 2;
end
if not(isfield(options,'capsizefac'))
    options.capsizefac = 2;
end
fdnames = fieldnames(parameters);
para1           =   fdnames{1};
values1         =   parameters.(para1);

nr_algos=length(alg_names);     
colorscheme = [0.00000 0.44700 0.74100
               0.85000 0.32500 0.09800
               0.92900 0.69400 0.12500
               0.49400 0.18400 0.55600
               0.46600 0.67400 0.18800
               0.30100 0.74500 0.93300
               0.63500 0.07800 0.18400
               0.08000 0.39200 0.25100];
set(groot,'defaultAxesColorOrder',colorscheme)
if not(select_algos)
    nr_algos_used = nr_algos;
    which_algos = [1:nr_algos];
end
legendInfo=cell(1,nr_algos_used);
figure 
box on
for i=1:nr_algos_used
    values_y_c = [values_y(which_algos(i),:)];
    nr_paras = size(values_y,2);
    stdevs = zeros(1,nr_paras);
    lq = zeros(1,nr_paras);
    uq = zeros(1,nr_paras);
    med = zeros(1,nr_paras);
    for j = 1:nr_paras
        stdevs(j) = get_stdd(values_y(which_algos(i),j),values_y_all{which_algos(i),j});
        med(j) = get_med(values_y(which_algos(i),j),values_y_all{which_algos(i),j});
        lq(j) = get_lq(values_y(which_algos(i),j),values_y_all{which_algos(i),j});
        uq(j) = get_uq(values_y(which_algos(i),j),values_y_all{which_algos(i),j});    
    end
    h = errorbar(values1,values_y_c,lq,uq,'LineWidth',options.linewidth,'CapSize',options.capsizefac*options.linewidth);
    if isfield(options,'logy') && options.logy
        set(gca,'yscale','log') 
    end
    if isfield(options,'logx') && options.logx
        set(gca,'xscale','log')
    end
    hold on;
    if isfield(custom_options,'ColorOrderIndices')
        set(gca,'ColorOrderIndex',ColorOrderIndices(i));
    end
    legendInfo{i}=alg_names{which_algos(i)};
end
legend(legendInfo,'Interpreter','Latex','FontSize',15);
ax = gca;
ax.YAxisLocation = 'right';
for l=1:nr_algos_used
    if isfield(custom_options,'ColorOrderIndices')
        ax.Children(nr_algos+1-l).Color = colorscheme(l,:);
    end
    if isfield(custom_options,'markersize')
        ax.Children(nr_algos_used+1-l).MarkerSize = custom_options.markersize(l);
    end
end

if isfield(options,'xlim')
    xlim([options.xlim(1) options.xlim(end)])
end
if isfield(options,'ylim')
    ylim([options.ylim(1) options.ylim(end)])
end
if isfield(options,'yticks')
   yticks(options.yticks) 
end
if isfield(options,'ylabels')
   ax.YTickLabels = options.ylabels; 
end

if isfield(figure_names,'xname')
    xlabel(figure_names.xname,'interpreter','Latex');
else
    xlabel(para1,'interpreter','Latex');
end
if isfield(figure_names,'yname')
    ylabel(figure_names.yname,'interpreter','Latex');
end
if isfield(figure_names,'titlestr')
    set(gcf,'name',figure_names.titlestr)
end

end