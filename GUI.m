function varargout = x2mGUI(varargin)
% GUI MATLAB code for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 12-Feb-2018 18:54:41

% Begin initialization code - DO NOT EDIT

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);
clear_all(hObject, eventdata, handles,'First');
LoadServers(handles);
    

function varargout = GUI_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;



function query_Callback(hObject, eventdata, handles)
      
    if  handles.Auto.Value == 1
        emailGet;                               % get email to send job done    
    end
     
    
    check = checkObligatory(handles);
    
   
   
    
    if check ~= 1
    
    set_busy(hObject, eventdata, handles,1)     % set busy   
    servers = getGlobalDataSeversConnected;
     % if servers is empty try to load servers
     if isempty(servers)    
          msgbox('Either this is your first use of this tools, or there are no servers configurated. Please configurate them before quering');
          return;  
     end
    year = handles.agefrom.String;
    year_2 = handles.ageto.String;
    found = 0;

    format shortg
    c = clock;
    year = c(1)-str2double(year);
    year = num2str(year);
        
        if handles.range.Value == 1
            
            year_2 = c(1)-str2double(year_2);
            year_2 = num2str(year_2);
            
        else
            
            year_2 = 'NaN';
            
        end
        
       
           
           
           [data,found,modality,servers,projects] =  x2mQuery( servers,year,year_2,handles.Sex.Value,handles.range.Value);
                   
     
         if handles.Auto.Value ~= 1
            set(handles.modality,'String',modality,'visible','off','Enable','on');
            set(handles.project,'String',projects(:,1),'visible','on','Enable','on');
            
            % start of project set
            global project_counter;                                        %set this global so you can select proper subjects by project :D
            project_counter = projects;
            sizeProject = size(projects,1);
            
            v = repmat(1:sizeProject,1);
            v = v(:)';
            set(handles.project,'Value',v);
            % end of project set 
    
              for k = 1:size(servers,2);
                if servers(k).NumberOfHits > 0;
                    a = size(fieldnames(handles),1) - 28;

                     try
                         
                         server_base_name = strsplit(servers(k).name,'://');
                         server_base_name = strsplit(server_base_name{2},'.');
                         server_base_name = server_base_name{1};

                         box = copyobj(handles.checkbox1,handles.figure1);
                         box.Position(2) = handles.checkbox1.Position(2) - ( 0.04 * a);
                         box.Tag = server_base_name;
                         box.String = [ upper(server_base_name) ' Number of Hits ' num2str(servers(k).NumberOfHits) ]; 
                         box.Visible  = 'On';
                         box.Position(3) = 0.35;
                         handles.checkbox1.Visible = 'Off';
                         x = server_base_name;

                         handles.(x)= box;
                         guidata(handles.figure1,handles);

                     catch me

                          x2mAddToLog('random_control error',value1,value2,msg,'','','','','','');

                     end
                end
              end
         end
      
                x = [ 'Found ' num2str(found) ' subjects'  ];
                set(handles.found,'String',x,'visible','on');
                set(handles.download,'visible','on');
                set(handles.query,'visible','off');
                set(handles.upTo,'visible','on');
                setGlobalData(data);
                clear x;

    if found == 0 
        
           clear_all(hObject, eventdata, handles,'Random');
           set(handles.found,'String','None please requery','visible','on');
    end
    
    if handles.Auto.Value == 1 && size(data,1) > 0
               download_Callback (hObject, eventdata, handles)
    else
               set_busy(hObject, eventdata, handles,0)                          % unset busy 
    end 
        
    end
     
      
       
    %end 
 



function agefrom_Callback(hObject, eventdata, handles)

str=get(hObject,'String');
if isempty(str2num(str))
    set(hObject,'String','25');
    warndlg('Input must be numerical');
end




function agefrom_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ageto_Callback(hObject, eventdata, handles)

ageFrom = str2num(handles.agefrom.String);
str=get(hObject,'String');
if isempty(str2num(str))
    
    set(hObject,'String','99');
    warndlg('Input must be numerical');
    
elseif ageFrom > str2num(str)
    set(hObject,'String',num2str(ageFrom + 1)); 
    errordlg('Age to should be greater or equal to Age From');
end



function ageto_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Sex_Callback(hObject,eventdata,handles)



function Sex_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function range_Callback(hObject, eventdata, handles)

if handles.range.Value == 1
    set(handles.ageto,'visible','on');
    set(handles.agefrom,'string','Age From');
else
    set(handles.ageto,'visible','off');
    set(handles.agefrom,'string','Age')
end



function edit5_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function modality_Callback(hObject, eventdata, handles)




function modality_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function download_Callback(hObject, eventdata, handles,regexType)

set_busy(hObject, eventdata, handles,1) % set busy 
% checkGlobalServersToDownload(handles);
data = getGlobalData;
maxSubjects = str2num(handles.upTo.String);
if maxSubjects == 0;
    maxSubjects = inf;
end

global serversConnected
global project

noSubjects = handles.found.Value;

if noSubjects == 789789
   noSubjects = size(data,1);
end  

if noSubjects > 0
    regexType = handles.regexType.String;
    if strcmp(regexType,'regex Type')
       regexType = ''; 
    end
    success = x2mDownloadData(data,maxSubjects,regexType,serversConnected,handles.Auto.Value,project,noSubjects);


    clear_all(hObject, eventdata, handles,'Random');



    if handles.Auto.Value == 1
        global email
        x2mSendMail(email)
    else
        set_busy(hObject, eventdata, handles,0) % unset busy
        msgbox('Operation Completed check folder named with today date in current folder');
    end
    x2mPrintLog;
    LoadServers(handles);
else
    msgbox('Operation can not be done since you selected 0 subjects via "by Project selection"');
end



function handles = clear_Callback(hObject, eventdata, handles)
    
handles = clear_all(hObject, eventdata, handles,'Random');
guidata(hObject, handles);
 
%global variables functions - store/read

function setGlobalData(val)
global data
data = getGlobalData;
if size(data) == 0 
    data = val;
else
    for i = 1:size(val)
        index = size(data,1);
        data(index +1,1) = val(i);
        data(index +1,2) = val(i,2);
        data(index +1,3) = val(i,3); 
        data(index +1,4) = val(i,4); 
    end
end


function r = getGlobalData

global data

r = data;

function clearGlobalData(type)
if strcmp(type,'First')
    clearvars -global 
else
    clearvars -global data
end

function setGlobalDataServersConnected(val)

global serversConnected

if size(serversConnected) == 0;
    
    serversConnected = val;
    
else
    
    serversConnected(size(serversConnected,2)+1) = val;

end
function r = getGlobalDataSeversConnected
global serversConnected
r = serversConnected;

% end of global variables




function upTo_Callback(hObject, eventdata, handles)

str=get(hObject,'String');
if isempty(str2num(str))
    set(hObject,'String','99');
    warndlg('Input must be numerical');
elseif str2num(str) > 50
    warndlg('You want to query for large number of subjects, it will take time');
end


function upTo_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function handles = clear_all(hObject, eventdata, handles,type)
       handles = set_gui_handles(handles);
       clearGlobalData(type);
       guidata(hObject, handles);
        %clear all;   % 
        % clc;
        % set(handles.upTo,'String','5','visible','off');
       



function addServer_Callback(hObject, eventdata, handles)

servers = getGlobalDataSeversConnected;

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

            folder = userpath;
            fullMatFileName = fullfile(folder(1:end-1),  'servers.mat');
            save(fullMatFileName,'servers')
            LoadServers(handles);

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
            folder = userpath;
            fullMatFileName = fullfile(folder(1:end-1),  'servers.mat');
            save(fullMatFileName,'servers')
            LoadServers(handles);
        catch baseException
            disp([ baseException.identifier baseException.message ]);
        end
    end
end
   

function LoadServers(handles)

ConnectedServersCounter = 0; %counter of how many servers are connected;
clearvars -global serversConnected       
try
    
    folder = userpath;
    fullMatFileName = fullfile(folder(1:end-1),  'servers.mat');
    servers = load(fullMatFileName);
    servers = servers.servers;
    
    for n = 1:size(servers,2)
        try  
           %  servers(n).password = x2mPasswordDecrypt( servers(n).password);
             x2mCheckConnection(servers(n).name,servers(n).user,servers(n).password,'Check connection');
             servers(n).NumberOfHits = '0';
             servers(n).Connect = 'X';
             servers(n).Check = 'X';
             ConnectedServersCounter = ConnectedServersCounter + 1;
             setGlobalDataServersConnected(servers(n));
        catch baseException  
            
    	end
        
    end
    catch me
      msgbox('Either this is your first use of this tools, or there are no servers configurated. Please configurate them before quering');
end
if ConnectedServersCounter == 0
    stringConnectedServersCounter = 'None';
    set(handles.DeleteServer,'visible','off');
    
else 
    stringConnectedServersCounter = num2str(ConnectedServersCounter);
    set(handles.DeleteServer,'visible','on');
end
handles.ServersConnectedCount.String = [ stringConnectedServersCounter ' Servers Connected'] ;

function set_busy(hObject,eventdata,handles,flag_busy)

%set Global show BUSY
if flag_busy == 1 && handles.Manual.Value == 1
    handles.Busy.Visible = 'On';
    set(handles.Busy, 'Visible','On');
else
    handles.Busy.Visible = 'Off';     
end

guidata(hObject, handles);
pause(0.2);
for i = 1:size(handles)        % maybe try to block buttons from being clicked?
    
end

function check = checkObligatory(handles)           %checks obligatory fields;
 
 upTo = str2num(handles.upTo.String);
 ageFrom = str2num(handles.agefrom.String);
 ageTo = str2num(handles.ageto.String);
 ageRange = handles.range.Value;
 
check = 0;
if ( isempty(upTo) )   %|| upTo < 1
    
    check = 1; 
    handles.upTo.String = '10';
    errordlg('Up To subjects can not be empty, automatically set to 10');
    
end

if ( isempty(ageFrom) || ageFrom < 0)
    
    check = 1;
    handles.agefrom.String = '25';
    errordlg('Age from cant be empty or lesser than 0, automatically set to 25');
    
end

if ageRange == 1
    
if ( isempty(ageTo) || ageTo < 0 )
    
    handles.ageto.String = '25';
    check = 1;
    errordlg('Age to cant be empty or lesser than 0, automatically set to 25');
    
end

end

function handles = set_gui_handles(handles)

   x = {};
   set(handles.download,'visible','off');
   set(handles.query,'visible','on');
   set(handles.modality,'String',x,'visible','off');
   set(handles.found,'String','None','visible','on');
   set(handles.agefrom,'String','AgeFrom');
   set(handles.ageto,'String','AgeTo','visible','off');
   set(handles.range,'Value',0);
   set(handles.project,'String',x,'visible','off');
   set(handles.Busy,'visible','off')
   set(handles.regexType,'String','regex Type')
   set(handles.Sex,'Value',1)
  % a = size(fieldnames(handles)) - 26;
   fieldnamesV = fieldnames(handles);
   if size(fieldnamesV,1) > 28 
       for i = 29:size(fieldnamesV,1)
            delete(handles.(fieldnamesV{i}));
            handles = rmfield(handles,fieldnamesV{i});
       end
   end
   
 function checkGlobalServersToDownload(handles)
     
     global serversConnected
     names = fieldnames(handles);
     for i = 26:size(names,1)
         if handles.(names{i}).Value == 0
             for k = 1:size(serversConnected,2)
              check = strfind(serversConnected(k).name,names{i});
              if ~isempty(check)
                  serversConnected(k).Check = ' ';
              end
             end
         end
     end
     
function emailGet
    
global email
checkMail = 0;

while checkMail == 0    
    
    prompt = {'Enter email address to send message when job is done:'};
    dlg_title = 'Email to send';
    num_lines = 1;
    if isempty(email)
        defaultans = {'zszymanski26@gmail.com'};
    else
        defaultans = {email};
    end
    
    answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
    
    if ~isempty(answer)
        k = strfind(answer{1},'@');                                 %basic Check if inpute contains @ -> 2do determine if adres email is valid
      
        if ~isempty(k)
            email = answer{1};
            checkMail = 1;
        end
    else
        break
    end
end



function regexType_Callback(hObject, eventdata, handles)
% hObject    handle to regexType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of regexType as text
%        str2double(get(hObject,'String')) returns contents of regexType as a double


% --- Executes during object creation, after setting all properties.
function regexType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to regexType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in project.
function project_Callback(hObject, eventdata, handles)
% hObject    handle to project (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns project contents as cell array
%        contents{get(hObject,'Value')} returns selected item from project
counter = 0;
global project_counter;
global project;
project = [];
for i = 1:size(hObject.Value,2)
       counter = counter + project_counter{hObject.Value(i),3}; % to determine what is acctual size of subjects;
       project{i,1} = project_counter(hObject.Value(i),2);
end
stringFound = [ 'Found ' num2str(counter) ' subjects'  ];
set(handles.found,'String',stringFound,'visible','on','Value',counter);



% --- Executes during object creation, after setting all properties.
function project_CreateFcn(hObject, eventdata, handles)
% hObject    handle to project (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usuall have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in DeleteServer.
function DeleteServer_Callback(hObject, eventdata, handles)
 try
     
     folder = userpath;
     fullMatFileName = fullfile(folder(1:end-1),  'servers.mat');
     servers = load(fullMatFileName);
     servers = servers.servers;
     d = servers;
     str = {d.name};
    [s,v] = listdlg('PromptString','Select a file:',...
                    'SelectionMode','single',...
                    'ListString',str,...
                    'OKString','Options',...
                    'ListSize', [ 220 300 ]    );
    
    if v == 1;
           
            warning('off','all')
            choice = questdlg(['What action on ' servers(s).name ' ?'], ...
            ['Options on' servers(s).name ], ...
            'Delete','Change','Cancel','');

            if strcmp('Delete',choice)

                servers(s) = [];


                save(fullMatFileName,'servers')
                LoadServers(handles);
            elseif strcmp('Change',choice)

                prompt = {'Enter user name to server:','Enter password to server:'};
                dlg_title = ['Change connection to ' servers(s).name];
                num_lines = 1;
                defaultans = {servers(s).user,servers(s).password};
                server_temp = inputdlg(prompt,dlg_title,num_lines,defaultans);

                if ~isempty(server_temp)

                    value1 = server_temp{1};
                    value2 = server_temp{2};

                    try
                        x2mCheckConnection(servers(s).name,value1,value2,'Adding server');
                        servers(s).user = value1;
                        servers(s).password = value2;
                        save(fullMatFileName,'servers')
                        LoadServers(handles);
                    catch me
                        disp([ 'Wrong User or Password to server ' servers(s).name ]);
                    end
                end
            
        end
    end
    warning('on','all')
 catch me
     warning('on','all')
     disp(me.message);
 end
