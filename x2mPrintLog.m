function x2mPrintLog() 
global log;
c = clock;
year = num2str(c(1),'%02d');
month = num2str(c(2),'%02d');
day = num2str(c(3),'%02d');
hour = num2str(c(4),'%02d');
min = num2str(c(5),'%02d');
upath = userpath;
folder_date_name = fullfile(upath(1:end-1),[year '_' month '_' day]);
warning('off','all')
mkdir(folder_date_name);
writetable(log,fullfile(folder_date_name, ['log_' year '_' month '_'  day '_'  hour '_'  min '.csv' ]),'Delimiter',',','WriteRowNames',true);
warning('on','all')
log = [];
