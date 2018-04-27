%Input/Arguments
    %servers - servers->structure (1,n) with fields name,user,password
        %name       - url of server with http:// or https:// ex. 'https://central.xnat.org'
        %user       - login of user to this specific server
        %password   - password for user to this specific server
%Return/Values
    %scannersData - data of scanners in structure
 
function [scannersData] = x2mGetScanners(servers)

check_servers = exist('servers');

if check_servers == 0
    servers = [];
end   

% if servers are empty try to load servers
if isempty(servers)
   servers = x2mLoadServersNoGui;
   if isempty (servers)
      msgbox('Either this is your first use of this tools, or there are no servers configurated. Please configurate them before quering');
   end 
end


scannersData = [];
for i = 1:size(servers,2)
    %set basic parameters
    user = servers(i).user;
    password = servers(i).password;
    server = servers(i).name;
    
    %set up options for rest 
    options = weboptions('Username',user,'Password',password,'Timeout',940);
    
    url = [ server '/data/archive/scanners' ];
    try %http errors log
            dataQuery = webread(url, options); % default - get
            x2mAddToLog('scanner-query',server,user,'OK','','','','',dataQuery.ResultSet.totalRecords,'');
             server_inner_name = strsplit(server,'://');
             server_inner_name = strsplit(server_inner_name{2},'.');
      
             scannersData.(server_inner_name{1}).data = dataQuery.ResultSet.Result;
             scannersData.(server_inner_name{1}).server = server;
             scannersData.(server_inner_name{1}).numberOfHits = dataQuery.ResultSet.totalRecords;
    catch me
            x2mAddToLog('scanner-query',server,user,me.message ,'','','','','','');
    end

end    
