function postprocess_fig_LRRS(nr_plots,xname,yname,varargin)
% This function post-processes a figure plot, modifying axes labels,
% plot colors and plot markers.
markers = {'-x', '-+', '-*', '-o','-x', '-s', '-d', '-^', '-v', ...
           '-x', '-+', '-*', '-o','-x', '-s', '-d', '-^', '-v'};
 
if nargin >= 4 
  custom_options = varargin{1};
  if isfield(custom_options,'markers')
      markers =  custom_options.markers;
  end
  if isfield(custom_options,'ColorOrderIndices')
      ColorOrderIndices =  custom_options.ColorOrderIndices;
  end
else
    custom_options = [];
end


colorscheme = [0.00000 0.44700 0.74100
                   0.85000 0.32500 0.09800
                   0.92900 0.69400 0.12500
                   0.49400 0.18400 0.55600
                   0.46600 0.67400 0.18800
                   0.30100 0.74500 0.93300
                   0.63500 0.07800 0.18400
                   0.08000 0.39200 0.25100
                   0.00000 0.00000 0.00000
                   0.85000 0.32500 0.09800
                   0.92900 0.69400 0.12500
                   0.49400 0.18400 0.55600];
set(groot,'defaultAxesColorOrder',colorscheme)
ax = gca;
for l=1:nr_plots
    if strcmp(class(ax.Children),'matlab.graphics.chart.primitive.Scatter')
        if isfield(custom_options,'ColorOrderIndices')
            ax.Children(nr_plots+1-l).CData = colorscheme(ColorOrderIndices(l),:);
        end
        if isfield(custom_options,'markers')
            ax.Children(nr_plots+1-l).Marker = markers{l};
        end
        if isfield(custom_options,'markerssize')
            ax.Children(nr_plots+1-l).SizeData = custom_options.markerssize{l};
        end
    else
        if isfield(custom_options,'ColorOrderIndices')
            ax.Children(nr_plots+1-l).Color = colorscheme(ColorOrderIndices(l),:);
        end
        if isfield(custom_options,'markerssize')
            ax.Children(nr_plots+1-l).MarkerSize = custom_options.markerssize{l};
        end
    end
end 
xlabel(xname,'interpreter','Latex');
ylabel(yname,'interpreter','Latex');

end     
