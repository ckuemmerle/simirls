function [s_c,S_largest,ind_absE]=update_sparspara(S_mat,delta,s_upper)
%  Given a matrix 'S_mat' and a positive threshold 'delta', this function
%  computes the value of 's_c', which counts the elements in S_mat with a
%  magnitude larger than 'delta' (adjusted by a very small tolerance 
%  'tol_precision' to account for numerical precision issues). The function
%  also returns the absolute value of the coordinates of S_mat with values
%  larger than 'delta' via 'S_largest', and a sorted (linear) index set
%  'ind_absE' that contains the locations of these large coordinates within
%  'S_mat'.
%  The positive integer 's_upper' serves as an upper bound for 's_c'.
tol_precision = 1e-10;

absS_mat=abs(S_mat);
ind_absE= find(absS_mat>delta+tol_precision);
s_c = length(ind_absE);
S_largest   = absS_mat(ind_absE);

if s_c > s_upper
    [~,ind]=sort(absS_mat,'descend');
    ind_absE = sort(ind(1:s_upper));
    S_largest   = absS_mat(ind_absE);
    s_c = length(ind_absE);
end

if s_c == 0
    S_largest = [];
    ind_absE = [];
end
end

