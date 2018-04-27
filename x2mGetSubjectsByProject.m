%Input/Arguments
    %servers - servers->structure (1,n) with fields name,user,password
        %name       - url of server with http:// or https:// ex. 'https://central.xnat.org'
        %user       - login of user to this specific server
        %password   - password for user to this specific server
    %projectsData - projects->structure containing result data from function getProjects.m
        %can be empty then function getProjects is called
%Return/Values
    %dataSubjects - data of subjects by Project in structure
    %projectData - if input is empty then call function getProjects this is reurnt of it's call




function [subjectsByProjectData,projectsData] = x2mGetSubjectsByProject(servers,projectsData)

check_projectsData = exist('projectsData');
check_servers = exist('servers');

if check_servers == 0
    servers = [];
end    

if check_projectsData == 0
    projectsData = [];
end

% if servers are empty try to load servers
if isempty(servers)
   servers = x2mLoadServersNoGui;
   if isempty (servers)
      msgbox('Either this is your first use of this tools, or there are no servers configurated. Please configurate them before quering');
   end 
end

%if projectsData are empty try to load them by function getprojectsData
if isempty(projectsData)
   projectsData = x2mGetProjects(servers);
end



subjectsByProjectData = [];
for i = 1:size(servers,2)
    %set basic parameters
    user = servers(i).user;
    password = servers(i).password;
    server = servers(i).name;
    
    %set up options for rest 
    options = weboptions('Username',user,'Password',password,'Timeout',940);
    
    %setup server name to wchich corresponding projectsData get subjects 
    server_inner_name = strsplit(server,'://');     
    server_inner_name = strsplit(server_inner_name{2},'.');
    
    subjectsByProjectData.(server_inner_name{1}).numberOfHits = 0;
    for k = 1:str2num(projectsData.(server_inner_name{1}).numberOfHits)
    projectID = projectsData.(server_inner_name{1}).data(k).ID;    
        url = [ server '/data/archive/projectsData/' projectID '/subjects' ];
        try %http errors log
                dataQuery = webread(url, options); % default - get
                x2mAddToLog('subjectByProject-querry',server,user,'OK','','','','',dataQuery.ResultSet.totalRecords,'');


                 
                 subjectsByProjectData.(server_inner_name{1}).server = server;
                 subjectsByProjectData.(server_inner_name{1}).numberOfHits = subjectsByProjectData.(server_inner_name{1}).numberOfHits + str2num(dataQuery.ResultSet.totalRecords);
                 subjectsByProjectData.(server_inner_name{1}).(projectID).numberOfHits = dataQuery.ResultSet.totalRecords;
                 subjectsByProjectData.(server_inner_name{1}).(projectID).data = dataQuery.ResultSet.Result;
        catch me
                x2mAddToLog('subjectByProject-querry',server,user,me.message ,'','','','','','');
        end
    end
end
