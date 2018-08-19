function [selpath,flagServers] = x2mSetPath
    selpath = [];
    flagServers = false;
    while isempty(selpath);
        selpath = uigetdir;
        if selpath == 0;
            selpath = [];
            disp('Please provide path to your data folder')
            continue
        end       
        try
        % try to load servers if succesful set flagServers to 'X'
        fullMatFileName = fullfile(selpath,  'servers.mat');
         load(fullMatFileName);
         flagServers = true;
        catch
            flagServers = false;
        end   
      
    end