function x2mAddServersNoGui(selpath)
servers = [];

while isempty(servers)    
    servers = x2mAddServer(selpath,servers);
	
    if isempty(servers)
        disp('Error adding server, please try again')
    end
end
while 1 ~= 0
 servers = [];
 dlgTitle    = 'Adding servers';
 dlgQuestion = 'Do you wish to add more servers?';
 answer = questdlg(dlgQuestion,dlgTitle,'Yes','No', 'Yes');
if strcmp(answer,'No')
    break
end
    servers = x2mAddServer(selpath,servers);
    if isempty(servers)
        disp('Error adding server, please try again')
    end
end