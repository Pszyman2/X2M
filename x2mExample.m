%%%x2mExample
%this function download all data for subjects in specific project and save
%log to CSV in user path.
%Steps 
    %1)Be sure that you have configurated userpath and structure with
    %servers in there, example of structure is in folder Xnat2Matlab/data
    %2)Project name should be known and should be valide, else error will ocurre
    %3)Then just call this function.
    
%for additional information go to functions or refer to documentation
function x2mExample(projectName)
     servers = x2mLoadServersNoGui; % load Servers
     if ~isempty(servers)
         upTo = 10;                     % upTo determine number of max subjects to be downloaded

        [dataSubjects,dataSubjectsDetailed] = x2mGetSubjectsFromProject(servers,projectName,upTo); % pass project name and server sturcute from function x2mLoadServersNoGui

        x2mDownloadDataSubjectNoGui(servers,dataSubjectsDetailed);

        x2mPrintLog;
        disp('end of action check userpath folder for your data, and read log for additional information');
     else
         disp('check servers.mat in userpath, there is an error with servers or the authorization failed');
     end
                                                
    