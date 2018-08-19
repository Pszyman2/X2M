% this is to create basic age query and post it to XNAT
% recive json response and evaluate data
% name should be variable you query
% sex [2,3,4,5] = [Unknown,Male,Female,Other] -> [%U%,%M%,%F%,%O%]
% servers - structure of servers in GUI
% year - year to query if logicIn = 0 , query for precise year else range 
% year_2 - only if logicIn = 1 , then range for  year < Query < year2 

function [data,found,modality,servers,projects] = x2mQuery( servers,year,year_2,sex,logicIn,upTo)

if isempty(upTo)
    upTo = inf;
else
    upTo = upTo * 2;
end

currentCounter = 0;
    switch sex
        case 2
            sex = '%U%';
            query = 'Sex Unknown';
        case 3
            sex = '%M%';
            query = 'Sex - Male';
        case 4
            sex = '%F%';
            query = 'Sex - Female';
        case 5 
            sex = '%O%';
            query = 'Sex - Others';
        otherwise
            sex = '1';
    end

data = [];
modality = [];
projects = [];
logic = logicIn;
for i = 1:size(servers,2)
data_sub_temp = [];
options = weboptions('Username',servers(i).user,'Password',servers(i).password,'Timeout',60);

    if ~strcmp(servers(i).name,'https://db.humanconnectome.org')
    format shortg
    c = clock;
    year_temp_from = c(1)-str2double(year);
    year_temp_from = num2str(year_temp_from);
        
        if logicIn == 1
            
            year_temp_to = c(1)-str2double(year_2);
            year_temp_to = num2str(year_temp_to);
            
        else
            
            year_temp_to = 'NaN';
            
        end
    else
        year_temp_from = year;
        if logicIn == 1
        year_temp_to = year_2;
        else
        year_temp_to = year+5;
        end
    end
    
    query = '';
    logic = logicIn; 

    
    switch logic
        case 1 
            logic = '&lt;=';
            logic_2 = '&gt;=';
            
            if  ~(strcmp(servers(i).name,'https://db.humanconnectome.org'))
            query = [ query ' YOB >= ' year_temp_to ' and YOB <= ' year_temp_from];
            else
                query = [ query ' AGE >= ' year_temp_to ' and AGE <= ' year_temp_from];
            end
            
        otherwise 
            logic = '=';                                               %change to "="
            if  ~(strcmp(servers(i).name,'https://db.humanconnectome.org'))
            query = [ query ' YOB = ' year_temp_from ];
            else
                query = [ query ' AGE = ' year_temp_from ];
            end
    end
    
    
url = servers(i).name;    
x2mAddToLog('query',url,options.Username,'send - query','','',query,'');

%construct XML to query database engine
x = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>';
x =  [ x  '<xdat:bundle ID="xs1510938844629" allow-diff-columns="1" secure="1" brief-description="test" xmlns:arc="http://nrg.wustl.edu/arc" xmlns:val="http://nrg.wustl.edu/val" xmlns:pipe="http://nrg.wustl.edu/pipe" xmlns:wrk="http://nrg.wustl.edu/workflow" xmlns:scr="http://nrg.wustl.edu/scr" xmlns:xdat="http://nrg.wustl.edu/security" xmlns:cat="http://nrg.wustl.edu/catalog" xmlns:prov="http://www.nbirn.net/prov" xmlns:xnat="http://nrg.wustl.edu/xnat" xmlns:xnat_a="http://nrg.wustl.edu/xnat_assessments" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://nrg.wustl.edu/workflow https://czarnobyl.ibib.waw.pl/schemas/workflow.xsd http://nrg.wustl.edu/catalog https://czarnobyl.ibib.waw.pl/schemas/catalog.xsd http://nrg.wustl.edu/pipe https://czarnobyl.ibib.waw.pl/schemas/repository.xsd http://nrg.wustl.edu/scr https://czarnobyl.ibib.waw.pl/schemas/screeningAssessment.xsd http://nrg.wustl.edu/arc https://czarnobyl.ibib.waw.pl/schemas/project.xsd http://nrg.wustl.edu/val https://czarnobyl.ibib.waw.pl/schemas/protocolValidation.xsd http://nrg.wustl.edu/xnat https://czarnobyl.ibib.waw.pl/schemas/xnat.xsd http://nrg.wustl.edu/xnat_assessments https://czarnobyl.ibib.waw.pl/schemas/assessments.xsd http://www.nbirn.net/prov https://czarnobyl.ibib.waw.pl/schemas/birnprov.xsd http://nrg.wustl.edu/security https://czarnobyl.ibib.waw.pl/schemas/security.xsd">'];
x =  [ x  '<xdat:root_element_name>xnat:subjectData</xdat:root_element_name>'];
x =  [ x  '<xdat:search_field>'];
x =  [ x  '<xdat:element_name>xnat:subjectData</xdat:element_name>'];
x =  [ x  '<xdat:field_ID>SUBJECT_LABEL</xdat:field_ID>'];
x =  [ x  '<xdat:sequence>0</xdat:sequence>'];
x =  [ x  '<xdat:type>string</xdat:type>'];
x =  [ x  '<xdat:header>Subject</xdat:header>'];
x =  [ x  '</xdat:search_field>'];
x =  [ x  '<xdat:search_field>'];
x =  [ x  '<xdat:element_name>xnat:subjectData</xdat:element_name>'];
x =  [ x  '<xdat:field_ID>GENDER</xdat:field_ID>'];
x =  [ x  '<xdat:sequence>1</xdat:sequence>'];
x =  [ x  '<xdat:type>string</xdat:type>'];
x =  [ x  '<xdat:header>Gender</xdat:header>'];
x =  [ x  '</xdat:search_field>'];
x =  [ x  '<xdat:search_field>'];
x =  [ x  '<xdat:element_name>xnat:subjectData</xdat:element_name>'];
x =  [ x  '<xdat:field_ID>HANDEDNESS</xdat:field_ID>'];
x =  [ x  '<xdat:sequence>2</xdat:sequence>'];
x =  [ x  '<xdat:type>string</xdat:type>'];
x =  [ x  '<xdat:header>Hand</xdat:header>'];
x =  [ x  '</xdat:search_field>'];
x =  [ x  '<xdat:search_field>'];
x =  [ x  '<xdat:element_name>xnat:subjectData</xdat:element_name>'];
x =  [ x  '<xdat:field_ID>DOB</xdat:field_ID>'];
x =  [ x  '<xdat:sequence>3</xdat:sequence>'];
x =  [ x  '<xdat:type>integer</xdat:type>'];
x =  [ x  '<xdat:header>YOB</xdat:header>'];
x =  [ x  '</xdat:search_field>'];
x =  [ x  '<xdat:search_field>'];
x =  [ x  '<xdat:element_name>xnat:subjectData</xdat:element_name>'];
x =  [ x  '<xdat:field_ID>EDUC</xdat:field_ID>'];
x =  [ x  '<xdat:sequence>4</xdat:sequence>'];
x =  [ x  '<xdat:type>integer</xdat:type>'];
x =  [ x  '<xdat:header>Education</xdat:header>'];
x =  [ x  '</xdat:search_field>'];
x =  [ x  '<xdat:search_field>'];
x =  [ x  '<xdat:element_name>xnat:subjectData</xdat:element_name>'];
x =  [ x  '<xdat:field_ID>SES</xdat:field_ID>'];
x =  [ x  '<xdat:sequence>5</xdat:sequence>'];
x =  [ x  '<xdat:type>integer</xdat:type>'];
x =  [ x  '<xdat:header>Ses</xdat:header>'];
x =  [ x  '</xdat:search_field>'];
x =  [ x  '<xdat:search_field>'];
x =  [ x  '<xdat:element_name>xnat:subjectData</xdat:element_name>'];
x =  [ x  '<xdat:field_ID>MR_COUNT</xdat:field_ID>'];
x =  [ x  '<xdat:sequence>6</xdat:sequence>'];
x =  [ x  '<xdat:type>integer</xdat:type>'];
x =  [ x  '<xdat:header>MR Count</xdat:header>'];
x =  [ x  '</xdat:search_field>'];
if strcmp(servers(i).name,'https://db.humanconnectome.org')
 x = [ x  '<xdat:search_field>' ];
 x = [ x  '<xdat:element_name>xnat:subjectData</xdat:element_name>' ];
 x = [ x  '<xdat:field_ID>AGE_RANGE</xdat:field_ID>' ];
 x = [ x  '<xdat:sequence>7</xdat:sequence>' ];
 x = [ x  '<xdat:type>string</xdat:type>' ];
 x = [ x  '<xdat:header>AGE_RANGE</xdat:header></xdat:search_field> ' ];
    
    
end

% search by criteria
if ~strcmp(year_temp_from,'NaN') || ~strcmp(sex,'1')
    
x =  [ x  '<xdat:search_where method="AND">'];

end

if ~strcmp(year_temp_from,'NaN') && ~(strcmp(servers(i).name,'https://db.humanconnectome.org'))
    
x =  [ x  '<xdat:child_set method="AND">'];
x =  [ x  '<xdat:criteria override_value_formatting="0">'];
x =  [ x  '<xdat:schema_field>xnat:subjectData.DOB</xdat:schema_field>'];
x =  [ x  '<xdat:comparison_type>' logic '</xdat:comparison_type>'];
x =  [ x  '<xdat:value>' year_temp_from '</xdat:value>'];
x =  [ x  '</xdat:criteria>'];
     if strcmp(year_temp_to,'NaN')

        x =  [ x  '</xdat:child_set>'];

     end
else
x =  [ x  '<xdat:child_set method="OR">'];
x =  [ x  '<xdat:criteria>'];
x =  [ x  '<xdat:schema_field>xnat:subjectData.AGE_RANGE</xdat:schema_field>'];
x =  [ x  '<xdat:comparison_type>BETWEEN</xdat:comparison_type>'];
x =  [ x  '<xdat:value>' year_temp_from '... and ' year_temp_to '...</xdat:value></xdat:criteria>'];
x =  [ x  '</xdat:child_set>'];    
end

if ~strcmp(year_temp_to,'NaN') && ~(strcmp(servers(i).name,'https://db.humanconnectome.org'))
x =  [ x  '<xdat:criteria override_value_formatting="0">'];
x =  [ x  '<xdat:schema_field>xnat:subjectData.DOB</xdat:schema_field>'];
x =  [ x  '<xdat:comparison_type>' logic_2 '</xdat:comparison_type>'];
x =  [ x  '<xdat:value>' year_temp_to '</xdat:value>'];
x =  [ x  '</xdat:criteria>'];
x =  [ x  '</xdat:child_set>'];

end

% /\ year
% \/ gender
if ~strcmp(sex,'1')
    
x = [ x '<xdat:child_set method="OR">'  ];
x = [ x '<xdat:criteria override_value_formatting="0">'  ];
x = [ x '<xdat:schema_field>xnat:subjectData.GENDER_TEXT</xdat:schema_field>'  ];
x = [ x '<xdat:comparison_type>LIKE</xdat:comparison_type>'  ];
x = [ x '<xdat:value>' sex '</xdat:value>'  ];
x = [ x '</xdat:criteria>'  ];
x = [ x '</xdat:child_set>'  ];

end

if ~strcmp(year_temp_from,'NaN') || ~strcmp(sex,'1')
x = [ x '</xdat:search_where>'  ];

end
% user allowed %

x =  [ x  '<xdat:allowed_user>'];
x =  [ x  '<xdat:login>' options.Username '</xdat:login>'];
x =  [ x  '</xdat:allowed_user>'];
x =  [ x  '</xdat:bundle>'];


url_post = [url '/data/search?format=json'];

try %HTTP error handler
    data_query = webwrite(url_post,x, options); % domyœlnie na post
    x2mAddToLog('query',url,options.Username,'query - OK','','',query,data_query.ResultSet.totalRecords);
catch me
   disp(me.identifier);
   x2mAddToLog('query',url,options.Username,['query - error - ' me.message],'','',query,'');
   
end


for n = 1:str2double(data_query.ResultSet.totalRecords)
    currentCounter = currentCounter + 1;
    if currentCounter > upTo
     break;
    end
    test = data_query.ResultSet.Result(n).subjectid;
    url_post2 = strcat(url,'/data/archive/subjects/',test,'?format=json');
    
    try 
        
     data_inner_query  = webread(url_post2, options); % domyœlnie na get
     disp([ 'Querying for detailed data of subject ' data_inner_query.items.data_fields.ID ])      
     x2mAddToLog('query',url,options.Username,['query inner - ok'],data_inner_query.items.data_fields.ID,'',query,'');
   
     
    catch me
        
        disp(me.identifier);
        x2mAddToLog('query',url,options.Username,['inner query - error - ' me.message],'','',query,'');
        
    end
    
    data_sub_temp{n,1} = data_inner_query;
    

   
end

 
    clear url;
    
    if size(data_sub_temp,1) >= 1;
        servers(i).NumberOfHits = size(data_sub_temp,1);    
        if ~isempty(data)

            size_data_old = size(data) + 1;                                 % to precise add servers to data 

                for k = 1:size(data_sub_temp)
                    counter = size(data{z,1}.items.children,1);
                    index = size(data,1);
                    data(index +1,1) = data_sub_temp(k);
                    projects{index+1,1} = data_sub_temp{k}.items.data_fields.project; 
        %            modality{index+1,1} = data_sub_temp{k}.items.children(counter).items(1).data_fields.modality; 
                    
                end
                
                data(size_data_old:size(data),2) = {servers(i).name};
                data(size_data_old:size(data),3) = {servers(i).user};
                data(size_data_old:size(data),4) = {servers(i).password};

        else
            
            data = data_sub_temp;
            data(1:size(data),2) = {servers(i).name};
            data(1:size(data),3) = {servers(i).user};
            data(1:size(data),4) = {servers(i).password};
            for z = 1:size(data,1)
                counter = size(data{z,1}.items.children,1);
                projects{z,1} = data_sub_temp{z}.items.data_fields.project;
         %       modality{z,1} = data_sub_temp{z}.items.children(counter).items(1).data_fields.modality;      
            end
        end
    end
end

projects_temp = projects;
projects = unique(projects);
for i = 1:size(projects,1)
    idx = strfind(projects_temp, projects{i});
    idx = find(not(cellfun('isempty', idx)));
    
    projects{i,2} = projects{i};
    projects{i,3} = length(idx);
    projects{i} = [ projects{i} '   -->' num2str(length(idx)) ];
end

modality = unique(modality);
modality{size(modality,1)+1,1} = 'ALL';
found = size(data,1);





    
