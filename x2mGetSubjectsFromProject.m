%Input/Arguments
    %servers - servers->structure (1,n) with fields name,user,password
        %name       - url of server with http:// or https:// ex. 'https://central.xnat.org'
        %user       - login of user to this specific server
        %password   - password for user to this specific server
    %project - project name as string
    %upTo - max number of subjects with detail data
        %if is set then dataSubjectsDetailed will be filled with detail data for upTo numers of subjects;

%Return/Values
    %dataSubjects - data of subjects in structure
    %dataSubjectsDetailed - data of subjects with all details ex. experiments
   
function [dataSubjects,dataSubjectsDetailed] = x2mGetSubjectsFromProject(servers,project,upTo)

%check if upTo is input and check if it's numer, if it's eq to 0 set it to inf.
% if upTo is not input there may be issiues with time, it may take alot of time to get all data of subjects 
dataSubjects = [];
dataSubjectsDetailed = [];
check_upTo = exist('upTo');
if check_upTo == 0 
   upTo = 0; 
elseif check_upTo == 1
    upTo = uint32(upTo);
    if isinteger(upTo) == 0
        msgbox('up to subjects must be double or intiger')
        return
    elseif upTo == 0
        upTo = uint32(inf);
    end
end
%if this is eq upTo end inner query
currentCount = uint32(0);                 

%check if servers exists if not try to load them
check_servers = exist('servers');
if check_servers == 0
    servers = [];
end   

% if servers is empty try to load servers
if isempty(servers)
   servers = x2mLoadServersNoGui;
   if isempty (servers)
      msgbox('Either this is your first use of this tools, or there are no servers configurated. Please configurate them before quering');
      return
   end 
end




dataSubjects = [];
for i = 1:size(servers,2)
    %set basic parameters
    user = servers(i).user;
    password = servers(i).password;
    server = servers(i).name;
    
    %set up options for rest 
    options = weboptions('Username',user,'Password',password,'Timeout',940);
    
    url = [ server '/data/archive/projects/' project '/subjects' ];
    try %http errors log
            dataQuery = webread(url, options);                              % default - get 
            x2mAddToLog('subject-query',server,user,'OK','','','',project,dataQuery.ResultSet.totalRecords,'');
            server_inner_name = strsplit(server,'://');
            server_inner_name = strsplit(server_inner_name{2},'.');
      
            dataSubjects.(server_inner_name{1}).data = dataQuery.ResultSet.Result;
            dataSubjects.(server_inner_name{1}).server = server;
            dataSubjects.(server_inner_name{1}).numberOfHits = dataQuery.ResultSet.totalRecords;
                try
%                   if upTo > str2num(dataQuery.ResultSet.totalRecords)
%                       upTo = str2num(dataQuery.ResultSet.totalRecords);
%                   end
                  for k=1:upTo
                      if currentCount >= upTo
                          break
                      end

                      subjectID = dataSubjects.(server_inner_name{1}).data(k).ID;
                      url_inner = [ server '/data/archive/subjects/' subjectID '?format=json'];
                      dataInnerQuerry = webread(url_inner, options);            % default - get
                      x2mAddToLog('subject-innerQuery',server,user,'OK','',subjectID,'',project,'','');
                      dataSubjectsDetailed.(server_inner_name{1}).(subjectID).dataDetailed = dataInnerQuerry.items(1).children;
                      dataSubjectsDetailed.(server_inner_name{1}).(subjectID).dataSubject  = dataSubjects.(server_inner_name{1}).data(k);
                      dataSubjectsDetailed.(server_inner_name{1}).(subjectID).server = server;
                      currentCount = currentCount + 1;
                  end
                catch me
                  x2mAddToLog('subject-innerQuery',server,user,me.message,'','','',project,'','');  
                end
                 
    catch me
            x2mAddToLog('subject-query',server,user,me.message ,'','','',project,'','');
    end

end    
