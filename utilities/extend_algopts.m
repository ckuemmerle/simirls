function [opts_new,alg_name_c,alg_name_out] = extend_algopts(opts_custom,...
    opts_extendnames,alg_name,alg_name_extend,varargin)
% Takes custom options contained in structure array 'opts_custom' and
% defines corresponding cell array with option structs 'opts_new' for each
% algorithm provided in 'alg_name' cell array. For each cell in
% 'alg_name_extend', create a seperate cell in 'opts_new' and
% 'alg_name_out' to account for different values of the corresponding
% setup attribute individually.
if not(isempty(varargin))
    opts_new = varargin{1};
else
    opts_new = cell(1,length(alg_name));
end
alg_name_out = alg_name;
alg_name_c = alg_name;
opts_added = struct;
names = fieldnames(opts_custom);
for i = 1:length(names)
    for j = 1:length(opts_extendnames)
        if strcmp(names{i},opts_extendnames{j})
            if length(opts_custom.(names{i})) > 1
                opts_added.(names{i}) = opts_custom.(names{i});
            end
        end
    end
end
names_added = fieldnames(opts_added);
for k = 1:length(names_added) 
    if ischar(opts_added.(names_added{k}))
        len_field = 1;
    else
        len_field = length(opts_added.(names_added{k}));
    end
    if iscell(alg_name_extend) && not(iscell(alg_name_c))
        container = zeros(1,length(alg_name));
        for i=1:length(alg_name_extend)
            container = container + contains(alg_name_c,alg_name_extend{i});
        end
        ind = find(container);
    else
        ind = find(contains(alg_name_c,alg_name_extend));
    end
    if iscell(opts_added.(names_added{k}))
        cellbool = true;
    else
        cellbool = false;
    end
    for i=1:length(ind)
        ind_c=ind(i)+(i-1)*(len_field-1);
        alg_name_ind_c=cell(1,len_field);
        alg_name_ind_out_c=cell(1,len_field);
        for ii=1:len_field
            alg_name_ind_c{ii}=[alg_name_c{ind_c}];
            if cellbool
                alg_name_ind_out_c{ii}=[alg_name_c{ind_c},' ',names_added{k},'=',num2str(opts_added.(names_added{k}){ii})];
            elseif ischar(opts_added.(names_added{k}))
                alg_name_ind_out_c{ii}=[alg_name_c{ind_c},' ',names_added{k},'=',num2str(opts_added.(names_added{k}))];
            else
                alg_name_ind_out_c{ii}=[alg_name_c{ind_c},' ',names_added{k},'=',num2str(opts_added.(names_added{k})(ii))];
            end
        end
        if ind_c < length(alg_name_c)
            alg_name_c= [alg_name_c(1:ind_c-1),alg_name_ind_c,alg_name_c(ind_c+1:end)];
            alg_name_out = [alg_name_out(1:ind_c-1),alg_name_ind_out_c,alg_name_out(ind_c+1:end)];
            opts_new= [opts_new(1:ind_c-1),repelem(opts_new(ind_c),len_field),opts_new(ind_c+1:end)];
        else
            alg_name_c= [alg_name_c(1:ind_c-1),alg_name_ind_c];
            alg_name_out= [alg_name_out(1:ind_c-1),alg_name_ind_out_c];
            opts_new= [opts_new(1:ind_c-1),repelem(opts_new(ind_c),len_field)];
        end
        for j=1:len_field
            if cellbool
                opts_new{ind_c+j-1}.(names_added{k})=opts_custom.(names_added{k}){j};
            elseif ischar(opts_added.(names_added{k}))
                opts_new{ind_c+j-1}.(names_added{k})=opts_custom.(names_added{k});
            else
                opts_new{ind_c+j-1}.(names_added{k})=opts_custom.(names_added{k})(j);
            end
        end
    end
    alg_name_c = alg_name_out;
end
if not(isempty(opts_custom))
    names = fieldnames(opts_custom);
    for l=1:length(alg_name_c)
        for i=1:length(names)
            bool = 0;
            for j=1:length(names_added)
                bool = bool + isequal(names(i),names_added(j));
            end
            if not(bool)
                if not(iscell(opts_custom.(names{i})))
                    opts_new{l}.(names{i})=opts_custom.(names{i});
                end
            end
        end
    end
end

end