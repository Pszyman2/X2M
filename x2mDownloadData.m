%this is mainly used in GUI
%data-> is output fucntion from Query function
%maxSubjects -> max no. of subjects to be downloaded
%regexType -> regex to find in experminet detail to be downloaded if
    %empty, all data for subject is downloaded
%serversConnected -> servers connected form GUI in structure
%type - 0,1 it's default use 0
%projects -> projects name in table to download only sufficient data
%noSubjects -> Number of subjects from data

function success_output = x2mDownloadData( data,maxSubjects,regexType,serversConnected,type,projects,noSubjects)

%this determinate how much data it is

A = exist('noSubjects');

if A == 0
    noSubjects = size(data,1);
end

SubjectsCounter = 0;
[success_output] = 0;
number_counter = 0;
for n = 1:size(data,1)
  
  %break if maxSubjects condition fulfilled
  if SubjectsCounter >= maxSubjects
      break    
  end
  
  % skip if server is unchecked( if serversConnected.Check == ' ') 
    skip = 0; 
    if type ~= 1 && ~isempty(serversConnected)
        for k = 1:size(serversConnected,2)
            if strcmp(data{n,2},serversConnected(k).name) && ~strcmp(serversConnected(k).Check,'X')
                skip = 1;
            end
        end
        
        if skip == 1 % skip if either server not connected or project is not relevant
           continue
        end  
        
    end 

 
     %skip if data.**********.project is not in projects
    if type ~= 1 && ~isempty(projects)
     skip = 1;
     for z = 1:size(projects,1)
         if strcmp(projects{z},data{n,1}.items.data_fields.project)
            skip = 0;         
         end
     end
     if skip == 1 % skip if either server not connected or project is not relevant
       continue
     end  
    end
    
      
 %end of skip
 
 
%initialize Data : 
    
    counter = size(data{n,1}.items.children,1);
    counterExperiment = size(data{n,1}.items.children(counter).items,1); % there can be multiple experiments per subject so it need to be divided in a way
    
                                                            % determine if any data have been downloaded for subject if yes set it to 1;
    
    for i=1:counterExperiment
        success = 0; 
        
        
        proj = data{n,1}.items.children(counter).items(i).data_fields.project;
        sub = data{n,1}.items.children(counter).items(i).data_fields.subject_ID;    
        exp = data{n,1}.items.children(counter).items(i).data_fields.id;
%        modality = data{n,1}.items.children(counter).items(i).data_fields.modality;
        
            
        
        
        %check for regexType for experiment
        scansTable = {};  
        if ~isempty(regexType)
            regexTable = strsplit(regexType,',')'; % transform regexType from string to table to querry
            counterSessions = size(data{n,1}.items.children(counter).items(i).children,1);
            
            for k = 1:size(data{n,1}.items.children(counter).items(i).children(counterSessions).items);
                for j = 1:size(regexTable,1) %check if in regexTable
                    check = strfind(upper(data{n,1}.items.children(counter).items(i).children(counterSessions).items(k).data_fields.type),upper(regexTable{j}));

                    if ~isempty(check)                                            % if there is no pattern in string continue to next loop
                        scansTable{size(scansTable,1)+1} = data{n,1}.items.children(counter).items(i).children(counterSessions).items(k).data_fields.ID;
                    end
                end
            end
         if isempty(scansTable)
            x2mAddToLog('download',data{n,2},data{n,3},'none regex found','',sub,exp,['regex-> ' regexType],'','');
            continiue
         end    
            
        end
        
        if ~isempty(scansTable)
           scans = '';
            for z = 1:size(scansTable,2)
                if isempty(scans) 
                    scans = scansTable{z};
                else
                    scans = [ scans ',' scansTable{z} ];
                end
            end
        else    
            scans = 'ALL';                                                   %change to ALL 
                    
        end
            

        %Rest download function
        url = [ data{n,2} '/data/projects/' proj '/subjects/' sub '/experiments/' exp '/scans/' scans '/files?format=zip' ]; %Give  ALL instead of 1%
        options = weboptions('Username',data{n,3},'Password',data{n,4},'Timeout',940);

        try %http errors log
            dataDownload = webread(url, options); % default - get
            x2mAddToLog('download',data{n,2},data{n,3},'OK','',sub,exp,['regex-> ' regexType],'','');
        %download data folder creation
            c = clock;

            %create home folder with name YYYY_MM_DD
            folder_temp = userpath;
            folder_date_name = fullfile(folder_temp(1:end-1),[num2str(c(1)) '_' num2str(c(2),'%02d') '_' num2str(c(3),'%02d')]); %strcat(strrep(userpath,';',''),'\',num2str(c(1)),'_',num2str(c(2),'%02d'),'_',num2str(c(3),'%02d'));
            warning('off','all')
            mkdir(folder_date_name);


            %create subfolders with specific server data SERVERNAME

            folder_inner_name = strsplit(data{n,2},'://');
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
        catch me                                                                     %catch error and add it to log
            number_counter = number_counter + 1;
            disp([ 'Downloaded subject '  sub ' - error check log ' num2str(number_counter) ' out of ' num2str(noSubjects) ' subjects'])
            x2mAddToLog('download',data{n,2},data{n,3},me.message,'',sub,exp,['regex-> ' regexType],'','');
            if success ~= 1;
                success = 0;
            end

        end
    end
    
    SubjectsCounter = SubjectsCounter + success;                                    %if success add 1 to counter of subjects downloaded
    
    if success == 1;
        number_counter = number_counter + 1;
        disp([ 'Downloaded subject '  sub ' - completed ' num2str(number_counter) ' out of ' num2str(noSubjects) ' subjects'])
        [success_output] = 1;
    end
end