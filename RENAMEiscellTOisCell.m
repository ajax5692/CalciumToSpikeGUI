[fileName filePath] = uigetfile;

cd(filePath)

load(fileName)

isCell = iscell;
save(fileName, '-regexp', '^(?!fileName|filePath|iscell|eventdata|hObject|handles$).')