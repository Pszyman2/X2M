function password = x2mPasswordDecrypt( password )
%basic decryption with Caesar Cipher
% %
% sizeTemp = size(password,2)
% shift = str2num(password((sizeTemp - 1):sizeTemp));
% 
% % decryption itself
% plain=password-shift;
% l=find(plain<65);
% plain(l)=plain(l)+26;
% l=find(plain<97);
% l=find(plain(l)>90);
% plain(l)=plain(l)+26;
% l=find(password==32);
% plain(l)=32;
% password=char(plain);
password = password;
