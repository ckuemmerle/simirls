function plot_results_success_phasetrans(value_mat,parameters,alg_names,option,...
    colors,yname)
% This function creates x-y plots that report on the values contained in
% 'value_mat' on the y-axis and the parameters contained in 'parameters'
% (first field of structure array 'parameters') on the x-axis.
% Different customization options exists, including the possibility to
% provide mean values with quantile-based errorbars.
fdnames = fieldnames(parameters);
para1           =   fdnames{1};
values1         =   parameters.(para1);
nr_algos=length(alg_names);    

colorscheme= hsv(7);
if isempty(colors)
    colors=cell(1,20);
    colors{1}='k';      lines{1}='*-';
    colors{2}='r';      lines{2}='*-';
    colors{3}='k';      lines{3}='*-';
    colors{4}='r';      lines{4}='*-';
    colors{5}='k';      lines{5}=':';
    colors{6}='r';      lines{6}=':';
    colors{7}='r';      lines{7}=':';
    colors{8}='m';        lines{8}='-';
    colors{9}=colorscheme(2,:);         lines{9}='-';
    colors{10}=colorscheme(3,:);        lines{10}='-';
    colors{11}=[255/255,165/255,0/255];lines{11}='-'; 
    colors{12}=colorscheme(4,:);  lines{12}='-'; 
    colors{13}=colorscheme(6,:);        lines{13}='-';
    colors{14}=colorscheme(7,:);        lines{14}='-';
    colors{15}='o--m';
    colors{16}='d-.k';
    colors{17}='d-.r';
    colors{18}='d-.g';
    colors{19}='d-.b';
    colors{20}='d-.m';  
end
if isfield(parameters,'LineWidth')
    linewidth = parameters.LineWidth;
else
    linewidth = 5;
end
if isfield(parameters,'markersize')
    markersize = parameters.markersize;
else
    markersize = 2;
end
if isfield(parameters,'lines')
    lines = parameters.lines;
end
if isfield(parameters,'errorbar') && contains(parameters.errorbar,'quantiles')
    if isfield(parameters,'lower_quantile')
        lower_quantile = parameters.lower_quantile;
    else
        lower_quantile = 0.25;
    end
    if isfield(parameters,'upper_quantile')
        upper_quantile = parameters.upper_quantile;
    else
        upper_quantile = 0.75;
    end
    if isfield(parameters,'lower_quantile_outer')
        lower_quantile_outer = parameters.lower_quantile_outer;
    else
        lower_quantile_outer = [];
    end
    if isfield(parameters,'upper_quantile_outer')
        upper_quantile_outer = parameters.upper_quantile_outer;
    else
        upper_quantile_outer = [];
    end
end
figure('Name',['Success rates for and varying values of ',para1]);
for i=1:nr_algos
    if strcmp(option,'logy')
        semilogy(values1,value_mat(i,:),lines{i},'LineWidth',linewidth);
    elseif strcmp(option,'loglog')
        if not(isfield(parameters,'errorbar'))
            loglog(values1,value_mat(i,:),lines{i},'LineWidth',linewidth);
        else
            if contains(parameters.errorbar,'quantiles')
                for j=1:length(values1)
                     lq(j) = get_lq(value_mat(i,j),parameters.allvalues(i,:,j),lower_quantile);
                     uq(j) = get_uq(value_mat(i,j),parameters.allvalues(i,:,j),upper_quantile);
                     if not(isempty(lower_quantile_outer))
                         lq_outer(j) = get_lq(value_mat(i,j),parameters.allvalues(i,:,j),lower_quantile_outer);
                     end
                     if not(isempty(upper_quantile_outer))
                         uq_outer(j) = get_lq(value_mat(i,j),parameters.allvalues(i,:,j),upper_quantile_outer);
                     end
                end
                errorbar(values1,value_mat(i,:),lq,uq,[],[],lines{i},'LineWidth',linewidth,'CapSize',12,'markersize',markersize,'Color',colors{i});
                if not(isempty(lower_quantile_outer))
                    hold on;
                    errorbar(values1,value_mat(i,:),lq_outer,uq_outer,[],[],lines{i},'LineWidth',linewidth,'CapSize',24,'markersize',markersize,'Color',colors{i});
                else
                    hold on;
                end
                set(gca,'xscale','log');
                set(gca,'yscale','log');
%                 set(gca,'markersize',1);
            end
        end
    else
        if isfield(parameters,'errorbar')
            if strcmp(parameters.errorbar,'std')
                for j=1:length(values1)
                    stdevs(j) = std(parameters.allvalues(i,:,j));   
                end
                errorbar(values1,value_mat(i,:),stdevs,stdevs,[],[],lines{i},'LineWidth',linewidth,'CapSize',12);
            elseif contains(parameters.errorbar,'quantiles')
                for j=1:length(values1)
                     lq(j) = get_lq(value_mat(i,j),parameters.allvalues(i,:,j),lower_quantile);
                     uq(j) = get_uq(value_mat(i,j),parameters.allvalues(i,:,j),upper_quantile);    
                end
                errorbar(values1,value_mat(i,:),lq,uq,[],[],lines{i},'LineWidth',linewidth,'CapSize',12);
            end 
            plot(values1,value_mat(i,:),lines{i},'LineWidth',linewidth);
        else
            plot(values1,value_mat(i,:),lines{i},'LineWidth',linewidth);
        end
    end
    hold on;
end
xlabel(para1,'interpreter','tex');
ylabel(yname,'interpreter','tex');
legend(alg_names,'Interpreter','Latex');
end     


