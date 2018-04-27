function servers = x2mAddServer(selpath,servers)


if size(servers,1) > 0    
    servers = rmfield(servers,{'Connect','NumberOfHits','Check'});    
    field1 = 'name';
    field2 = 'user';
    field3 = 'password';
    prompt = {'Enter server url:','Enter user name to server:','Enter password to server:'};
    dlg_title = 'Add Server';
    num_lines = 1;
    defaultans = {'https://czarnobyl.ibib.waw.pl','User','Password'};
    server_temp = inputdlg(prompt,dlg_title,num_lines,defaultans);
    
    if ~isempty(server_temp)
    
        value1 = server_temp{1};
        value2 = server_temp{2};
        value3 = server_temp{3};

        try

            x2mCheckConnection(value1,value2,value3,'Adding server');
          %  passwordEncrypted = x2mPasswordEncrypt(value3);
            servers(end+1) = struct(field1,value1,field2,value2,field3,value3);
           % setGlobalDataServersConnected(servers(end));
           % servers(end).password = passwordEncrypted;
            servers = servers;
            %make servers Unique
                a= {servers.name};
                b= {servers.user};
                c=cellfun(@(x,y) [x y],a', b','un',0);
                [ii,ii]=unique(c,'stable');
                servers=servers(ii);
            %make servers Unique
            
            fullMatFileName = fullfile( selpath,  'servers.mat');
            save(fullMatFileName,'servers')


        catch baseException
            disp([ baseException.identifier baseException.message ]);
        end
    end
else    

    field1 = 'name';  
    field2 = 'user'; 
    field3 = 'password';
    
    prompt = {'Enter server url:','Enter user name to server:','Enter password to server:'};
    dlg_title = 'Add Server';
    num_lines = 1;
    defaultans = {'https://czarnobyl.ibib.waw.pl','User','Password'};
    server_temp = inputdlg(prompt,dlg_title,num_lines,defaultans);
    
    if ~isempty(server_temp)
        
        value1 = server_temp{1};
        value2 = server_temp{2};
        value3 = server_temp{3};

        try

            x2mCheckConnection(value1,value2,value3,'Adding server');
          %  passwordEncrypted = x2mPasswordEncrypt(value3);
            servers = struct(field1,value1,field2,value2,field3,value3);
       %     setGlobalDataServersConnected(servers);
       %     servers.password = passwordEncrypted;
            
            %folder = selpath;
            fullMatFileName = fullfile(selpath,  'servers.mat');
            save(fullMatFileName,'servers')
        catch baseException
            disp([ baseException.identifier baseException.message ]);
        end
    end
end