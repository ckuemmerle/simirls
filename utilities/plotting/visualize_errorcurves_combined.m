function visualize_errorcurves_combined(errors,alg_name,varargin)
% This function provides plots for the values contained in cell array
% 'errors' where each cell corresponds to the values of a different
% algorithm, whose names are provided in the cell array 'alg_name'. Options
% exist for semi-logarithmic or standard plots.
plottype = 'semilogy';
titlestring = 'Relative error vs. iteration count';
ylabelstring = 'Relative Frobenius error (log-scale)';
if ~isempty(varargin)
    problem = [];
    for tt = 1:2:length(varargin)
        switch lower(varargin{tt})
            case 'plottype'
                switch lower(varargin{tt+1})
                    case 'standard'
                        plottype = 'standard';
                    case 'semilogy'
                        plottype = 'semilogy';
                end
            case 'titlestring'
                titlestring = varargin{tt+1};
            case 'ylabelstring'
                ylabelstring = varargin{tt+1};
        end
    end
else
    problem = [];
end
warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame')
nr_algos=length(alg_name);
if ~isequal(nr_algos,length(errors))
   error('Mismatch between provided number of algorithms and number of calculated error statistics.');
end

N=cell(1,nr_algos);
for i = 1:nr_algos
    N{i}=length(errors{i});
end

maxIt=N{1};
minIt=N{1};
for l=1:nr_algos
   maxIt=max(maxIt,N{l});
   minIt=min(minIt,N{l});
end
markers = {'-x', '-+', '-*', '-o','-x', '-s', '-d', '-^', '-v', ...
           '-x', '-+', '-*', '-o','-x', '-s', '-d', '-^', '-v', ...
           '-x', '-+', '-*', '-o'};
figure;

for l=1:nr_algos
    if strcmp(plottype,'semilogy')
        semilogy(errors{l},markers{l},'MarkerSize',8); 
    elseif strcmp(plottype,'standard')
        plot(errors{l},markers{l},'MarkerSize',8); 
    end
    hold on
end
xlabel('iteration $k$');
ylabel(ylabelstring,'Interpreter','latex');
legend(alg_name,'FontSize',12,'Interpreter','latex','FontSize',12);
if not(isempty(titlestring))
    title(titlestring)
    set(gcf,'name',titlestring)
end
        
end