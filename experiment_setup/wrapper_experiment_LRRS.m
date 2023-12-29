function [outs,parameters] = wrapper_experiment_LRRS(Example,...
    paras_experiment,instancesize,resultname,resulttext,varargin)
% This function executes experiments for the setup prescribed by 'Example',
% while varying the experimental parameters indicated by
% 'paras_experiment'. The number of independent runs is indicated by
% 'instancesize'. Finally, the data and resulting plots are saved in the
% subfolder 'data' together with a timestamp.
if nargin > 5
    option = varargin{1};
    if nargin > 6
        filename_note = varargin{2};
    end
else
    option = [];
end
[outs] = run_instances_LRRS(paras_experiment,instancesize,Example);
parameters.(paras_experiment.name) = paras_experiment.values;
if outs.nr_algos == 0
    alg_name = {'no_alg'};
    outs.alg_name = alg_name;
else
    Ns              = outs.Ns;
    times           = outs.times;
    success_count   = outs.success_count;
    successrate     = outs.successrate;
    success_threshold = outs.success_threshold;
    error_fro_rel   = outs.error_fro_rel;
    error_fro       = outs.error_fro;
    avg_error_rel   = outs.avg_error_rel;
    alg_name          = outs.alg_name;
end

plot_results_success_phasetrans(outs.(resultname),parameters,outs.alg_name,option,[],...
     [resulttext]);

curdate = datestr(now,'yyyy-mm-dd_HHMM-SS-FFF');
if nargin > 6
    if iscell(filename_note) && length(filename_note) == 2
        filename=['LRRS_',paras_experiment.name,'_',num2str(min(paras_experiment.values)),'_',...
            num2str(max(paras_experiment.values)),'_',Example.descr,'_',Example.samplemodel.mode,...
            '_',filename_note{2},'_',num2str(Example.(filename_note{1}).(filename_note{2}))];
    elseif iscell(filename_note) && length(filename_note) == 3
                filename=['LRRS_',paras_experiment.name,'_',num2str(min(paras_experiment.values)),'_',...
            num2str(max(paras_experiment.values)),'_',Example.descr,'_',Example.samplemodel.mode,...
            '_',filename_note{3},'_',num2str(Example.(filename_note{1}).(filename_note{2}).(filename_note{3}))];
    else
        filename=['LRRS_',paras_experiment.name,'_',num2str(min(paras_experiment.values)),'_',...
            num2str(max(paras_experiment.values)),'_',Example.descr,'_',Example.samplemodel.mode,...
            '_',filename_note{1},'_',num2str(Example.(filename_note{1}))];
    end
else
    filename=['LRRS_',paras_experiment.name,'_',num2str(min(paras_experiment.values)),'_',...
    num2str(max(paras_experiment.values)),'_',Example.descr,'_',Example.samplemodel.mode];
end
savefig(fullfile('data',[filename,'_',curdate,'.fig']));
save(fullfile('data',[filename,'_',curdate,'.mat']));

end