function password = x2mPasswordEncrypt ( password )
%basic encryption with Caesar Cipher
%shift number is randomized in the range of 1:26, number of shifts is contained within password itself
% shift = randi([10,26]);
% 
% %Operation of Encryption itself
% C=password+shift;
% l=find(C>122);
% C(l)=C(l)-26;
% l=find(C>90);
% l=find(C(l)<97);
% C(l)=C(l)-26;
% l=find(password==32);
% C(l)=32;
% password=char(C);
% password = [ password num2str(shift)];
password = password;




