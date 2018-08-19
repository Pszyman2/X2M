function [servers,me] = x2mLoadServersNoGui(selpath)

servers = [];
try
    % try to load servers
    fullMatFileName = fullfile(selpath,  'servers.mat');
    servers_temp = load(fullMatFileName);
    servers_temp = servers_temp.servers;
    me = 'No';
    for n = 1:size(servers_temp,2) %check connection of servers, if accesable then add it to [servers]
        try  
             x2mCheckConnection(servers_temp(n).name,servers_temp(n).user,servers_temp(n).password,'Check connection');
             if isempty(servers)
                servers = servers_temp(n);
             else
                servers(size(servers,2)+1) = servers_temp(n);
             end
        catch baseException  
              disp(['Error with server ' servers_temp(n).name]);
              disp(baseException.message);
    	end
        
    end      
catch me
              disp('No servers configurated or they are not in path folder');
              disp(me.message);
end