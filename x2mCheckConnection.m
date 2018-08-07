function  x2mCheckConnection(value1,value2,value3,type)

url = [value1 '/data/archive/scanners'];
options = weboptions('Username',value2,'Password',value3,'Timeout',60);
try
    
    data_querry = webread(url, options); % domyœlnie na get
    x2mAddToLog('check',value1,value2,['OK - ' type],'','','','');
catch me
    
    msgID = 'XNATMatTool:HttpError';
    msg = me.message;
    x2mAddToLog('check',value1,value2,msg,'','','','','');
    baseException = MException(msgID,msg);
    throw(baseException)

end

 