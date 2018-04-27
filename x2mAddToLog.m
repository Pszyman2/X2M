% year = num2str(c(1),'%02d');
% month = num2str(c(2),'%02d');
% day = num2str(c(3),'%02d');
function x2mAddToLog(type,server,user,error,subject,experiment,query,numerOfFile,voxelSize)
global    log;
global    time ;
global    action;
global    servers;
global    users;
global    errors;
global    querys;
global    subjects;
global    experiments;
global    numberOfFiles;
global    voxelSizes;  
c = clock;

hour = num2str(c(4),'%02d');
min = num2str(c(5),'%02d');
sec = num2str(ceil(c(6)),'%02d');

%allways filled data;
counter = size(time,1) + 1 ;
time{counter,1} = [ hour ':' min ':' sec ];
actions{counter,1} = type;
servers{counter,1} = server;
users{counter,1} = user;

if ~strcmp(error,'NONE')
    errors{counter,1} = error;
else
    
end


querys{counter,1} = query;
subjects{counter,1} = subject;
experiments{counter,1} = experiment;
numberOfFiles{counter,1} = numerOfFile;
voxelSizes{counter,1} =  voxelSize;


log = table(time,actions,servers,users,errors,querys,subjects,experiments,numberOfFiles,voxelSizes);
   
