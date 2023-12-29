function [Phi] = SampleGaussianPhi_matrix(n1,n2,m,std_dev)
%SampleGaussianPhi_matrix: This function samples i.i.d. Gaussian entries
% with 0 mean and standard deviation 'std_dev' and returns an (m x n1*n2)
% matrix 'Phi' containing such entries.
%           Input:
%           n1      = Number of rows of matrix to be recovered
%           n2      = Number of columns of matrix to be recovered 
%           m       = Number of measurements
%           std_dev = Standard deviation of entries (standard should be 1)
%          
%           Output:
%           Phi     = (m x (n1*n2)) matrix           
%Phi = zeros(m,d*m_chi);
Phi=normrnd(0,std_dev,m,n1*n2);

end
