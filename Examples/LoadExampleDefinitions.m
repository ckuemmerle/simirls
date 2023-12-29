function Examples = LoadExampleDefinitions()
% Loads example definitions contained in subfolder 'Examples' of the main 
% folder and returns information in cell array 'Examples'. Assumes that the
% current directory is located one level higher than subfolder 'Examples'.
currentdir = pwd;

def_files                          = dir([currentdir,'/Examples/*_def.m']);
total_num_defs                     = length(def_files);
if total_num_defs == 0
    mydir  = pwd;
    idcs   = strfind(mydir,'/');
    currdir = mydir(idcs(end)+1:end);
    parentDirectory = fileparts(cd);
    cd(parentDirectory);
    def_files                          = dir([currentdir,'/Examples/*_def.m']);
    total_num_defs                     = length(def_files);
    cd(currdir);
end
Examples                           = cell(1, total_num_defs);
for idx = 1 : total_num_defs
  eval(sprintf('Example = %s();', erase(def_files(idx).name, '.m')));
  Examples{idx}                    = Example;
end

end