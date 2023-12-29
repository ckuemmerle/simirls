function weight_vec = get_weight_vec(d1,d2,H,dH,tangent_para,...
    weight_op,increase_antisymmetricweights)
%get_weight_vec This function returns a weight vector "weight_vec" from the
% information of H and dH, cf. entries of D_{S_k} in [1].
%
% Reference:
% [1] Christian Kuemmerle and Claudio Mayrink Verdun, "A scalable second 
% order method for ill-conditioned matrix completion from few samples", 
% ICML 2021, 2021,
% http://proceedings.mlr.press/v139/kummerle21a/kummerle21a-supp.pdf.
R=size(H{1},1);
d=min(d1,d2);
D=max(d1,d2);
if isfield(weight_op,'symmetricflag')
    symmetricflag = weight_op.symmetricflag;
else
    symmetricflag = false;
end
if strcmp(tangent_para,'intrinsic')
    dim_tangent = R*(d1+d2-R);
    if weight_op.symmetricflag
       error('This needs to be updated.') 
    end
else
    if symmetricflag
        dim_core = R*((R+1)/2);
        dim_tangent = R*((R+1)/2+d1);
    else
        dim_core = R^2;
        dim_tangent = R*(d1+d2+R);
    end
end
weight_vec =zeros(dim_tangent,1);

if symmetricflag
    weight_vec(1:dim_core)        = H{1}(weight_op.symInd);
else
    weight_vec(1:dim_core)=H{1}(:);
end

if increase_antisymmetricweights
    if d1 == D
        if strcmp(tangent_para,'intrinsic')
            weight_vec((dim_core+1):(R*(d1)))=...
            reshape(kron(dH{1},ones(1,d1-R)).',[(d1-R)*R,1]);
            weight_vec((R*d1+1):dim_tangent)  =...
            reshape(kron(dH{2},ones(1,d2-R)),[(d2-R)*R,1]);
        else
            weight_vec((dim_core+1):(dim_core+R*d1))=...
            reshape(kron(dH{1},ones(1,d1)).',[d1*R,1]);
            if ~symmetricflag
                weight_vec((dim_core+R*d1+1):dim_tangent)  =...
                reshape(kron(dH{2},ones(1,d2)),[d2*R,1]);
            end
        end
    else
        if strcmp(tangent_para,'intrinsic')
            weight_vec((dim_core+1):R*d1)=...
            reshape(kron(dH{2},ones(1,d1-R)).',[(d1-R)*R,1]);
            weight_vec((R*d1+1):dim_tangent)  =...
            reshape(kron(dH{1},ones(1,d2-R)),[(d2-R)*R,1]);
        else
            weight_vec((dim_core+1):(dim_core+R*d1))=...
            reshape(kron(dH{2},ones(1,d1)).',[d1*R,1]);
            if ~symmetricflag
                weight_vec((dim_core+R*d1+1):dim_tangent)  =...
                reshape(kron(dH{1},ones(1,d2)),[d2*R,1]);
            end
        end
    end
else
    if strcmp(tangent_para,'intrinsic')
        weight_vec((dim_core+1):R*d1)=...
        reshape(kron(dH{2},ones(1,d1-R)).',[(d1-R)*R,1]);
        weight_vec((R*d1+1):dim_tangent)  =...
        reshape(kron(dH{1},ones(1,d2-R)),[(d2-R)*R,1]);
    else
        weight_vec((dim_core+1):(dim_core+R*d1))=...
        reshape(kron(dH{2},ones(1,d1)).',[d1*R,1]);
        if ~symmetricflag
            weight_vec((dim_core+R*d1+1):dim_tangent)  =...
            reshape(kron(dH{1},ones(1,d2)),[d2*R,1]);
        end
    end
end 
end

