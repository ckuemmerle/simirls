function samplemodel_out = prepare_samplemodel_LRRS(prob,samplemodel)
%prepare_samplemodel_LRRS This function computes/updates key parameters of 
% the ground truth and the sampling model, modifying suitable fields of
% 'samplemodel' and returning them via 'samplemodel_out'.
samplemodel_out = samplemodel;
[df_LR,df_JS,df_combined,~,~,~,...
    ~,~,~] = degfreedom(prob.n1,prob.n2,prob.K1,prob.n2,prob.r);
nentries = prob.n1*prob.n2;
samplemodel_out.m = ceil(samplemodel.oversampling*df_combined);
samplemodel_out.deg_freedom = df_combined;
samplemodel_out.deg_freedom_LR = df_LR;
samplemodel_out.deg_freedom_JS = df_JS;
samplemodel_out.nentriesX = nentries; %nentriesA
end

