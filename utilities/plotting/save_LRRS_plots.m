% This snippet script is used to save plots in different file formats.
savefig(strcat(filename,'.fig'))
fig=gcf;
saveas(fig,strcat(filename,'.eps'),'epsc')
saveas(fig,strcat(filename,'.pdf'))
if exist('matlab2tikz')
    cleanfigure; 
    matlab2tikz(strcat(filename,'.tex'),'height', '\figureheight', 'width', '\figurewidth',...
    'extraaxisoptions',['xlabel style={font=\tiny},',...
    'ylabel style={font=\tiny},'])
end