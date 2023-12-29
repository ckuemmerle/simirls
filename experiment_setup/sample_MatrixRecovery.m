function sampling = sample_MatrixRecovery(n1,n2,samplemodel)
%sample_MatrixRecovery This function creates a measurement operator for a 
% matrix recovery problem (low-rank / row-sparse / column-sparse / joint
% recovery).
sampling = struct;
sampling.m = samplemodel.m;

if strcmp(samplemodel.mode,'Gaussian_dense')
    if isfield(samplemodel,'std_dev') && ~isempty(samplemodel.std_dev)
        std_dev = samplemodel.std_dev;
    else
        std_dev = 1;
    end
    [Phi] = SampleGaussianPhi_matrix(n1,n2,samplemodel.m,std_dev);
    Phi=Phi./sqrt(samplemodel.m);
elseif strcmp(samplemodel.mode,'Gaussian_rank1')
    Amat = normrnd(0,1,sampling.m,n1);
    Bmat = normrnd(0,1,sampling.m,n2);
    Phi = zeros(samplemodel.m,n1*n2);
    for i = 1:samplemodel.m
        Phi(i,:) = reshape(Amat(i,:)'*Bmat(i,:),1,n1*n2);
    end
    Phi = Phi./sqrt(samplemodel.m);
elseif strcmp(samplemodel.mode,'Fourier_rank1')
    Amat = normrnd(0,1,sampling.m,n1);
    Bmat = normrnd(0,1,sampling.m,n2);
    F = fft(eye(sampling.m));
    FA = F*Amat./sqrt(samplemodel.m);
    FB = F*Bmat./sqrt(samplemodel.m);
    Phi = zeros(samplemodel.m,n1*n2);
    for i = 1:samplemodel.m
        Phi(i,:) = reshape(FA(i,:)'*conj(FB(i,:)),1,n1*n2);
    end
    Phi = Phi./sqrt(samplemodel.m);
else
    error('Sampling operators other than dense Gaussian not implemented yet.')
end
Phihat=zeros(samplemodel.m,n1*n2);
for i=1:samplemodel.m
    Phihat(i,:)=reshape(reshape(Phi(i,:),[n1,n2])',[1,n1*n2]);
end
sampling.Phi = Phi;
sampling.Phihat = Phihat;

end