%dataSubjectsDetailed -> structure with detail data of subjects
%you can get it from get functions x2m:
    % getSubjects, getSubjectsByProject, getSubjectFromProject
    
function x2mDownloadDataSubjectNoGui(selpath,servers,dataSubjectsDetailed)
    
    serverName = fieldnames(dataSubjectsDetailed);
    
    for k = 1:size(dataSubjectsDetailed,1)
        
        subjectName = fieldnames(dataSubjectsDetailed.(serverName{k}));
        host = dataSubjectsDetailed.(serverName{k}).(subjectName{1}).server; 
        index = find(strcmp({servers.name}, host ) == 1 );
        noSubjects = size(subjectName,1);                      %No. of subjects per server
        number_counter = 0;
        
        if isempty(index) 
            disp(['no user/password for ' host]);
            continue
            
        else
            user = servers(index).user;
            password = servers(index).password;
        end
        
        for i = 1:size(subjectName,1)
            number_counter = number_counter + 1;
            subData = dataSubjectsDetailed.(serverName{k}).(subjectName{i}).dataDetailed.items.data_fields; % get relevant informations to variable
           
            for j = 1:size(subData,2)
                proj = subData.project;
                sub = subData.subject_ID;
                exp = subData.ID;
                url = [ host '/data/projects/' proj '/subjects/' sub '/experiments/' exp '/scans/ALL/files?format=zip' ]; %Give  ALL instead of 1%
                options = weboptions('Username',user,'Password',password,'Timeout',940);

                try %http errors log
                    dataDownload = webread(url, options); % default - get
                    x2mAddToLog('download',host,user,'OK','',sub,exp,proj,'','');
                %download data folder creation
                    c = clock;

                    %create home folder with name YYYY_MM_DD
                    folder_date_name = fullfile(selpath,[num2str(c(1)) '_' num2str(c(2),'%02d') '_' num2str(c(3),'%02d')]); 
                    warning('off','all')
                    mkdir(folder_date_name);


                    %create subfolders with specific server data SERVERNAME

                    folder_inner_name = strsplit(host,'://');
                    folder_inner_name = strsplit(folder_inner_name{2},'.');


                    mkdir(folder_date_name,folder_inner_name{1});

                    mkdir(fullfile(folder_date_name,folder_inner_name{1},sub));

                   % folder = strcat(folder_date_name,'\',folder_inner_name{1},'\',sub);
                    folder = fullfile(folder_date_name,folder_inner_name{1},sub);
                    baseFileName = [sub '_' exp '.zip'];
                    fullFileName = fullfile(folder, baseFileName);
                    [fileID, message] = fopen(fullFileName, 'w');
                    fwrite(fileID,dataDownload);
                    fclose(fileID);

                    %unpack data to current location and delete ziped file

                    unzip(fullFileName,folder);
                    delete ( fullFileName );
                    success = 1;
                    warning('on','all')
                    disp([ 'Downloaded subject '  sub ' - completed ' num2str(number_counter) ' out of ' num2str(noSubjects) ' subjects'])
                catch me                                                                     %catch error and add it to log                    
                    
                    disp([ 'Downloaded subject '  sub ' - error check log ' num2str(number_counter) ' out of ' num2str(noSubjects) ' subjects'])
                    x2mAddToLog('download',host,user,me.message,'',sub,exp,proj,'');
                    
                    if success ~= 1;
                        success = 0;
                    end

                end

            end
  
        end
         
    end