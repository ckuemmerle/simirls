function [df_LR,df_JS,df_combined,df_s_squared,df_combined_RIP_1,...
    df_combined_RIP_2,m_phi_LR,m_phi_JS,m_phi_combined] = degfreedom(n1,n2,Kr,Kc,r)
%degfreedom Computes several notions of degrees of freedom.
df_LR = r*(n1 + n2 - r);
df_JS = Kr* n2;
df_combined = r*(Kr + Kc -r);
df_combined_RIP_1 = r.*(Kr + Kc).*log(exp(1)*max(n1./Kr,n2./Kc));
df_combined_RIP_2 = r.*(Kr + Kc).*log(max(n1./Kr,n2./Kc));
df_s_squared = (Kr * Kc);
m_phi_LR = df_LR/n2;
m_phi_JS = df_JS/n2;
m_phi_combined = df_combined/n2;

end

