function x2mSendMail ( recipient_email )
if ~isempty(recipient_email)
    try
    mail = 'xnat.spm.connector@gmail.com'; %Universal Gmail account
    password = 'nevermore';  %universal password
    setpref('Internet','SMTP_Server','smtp.gmail.com');

    setpref('Internet','E_mail',mail);
    setpref('Internet','SMTP_Username',mail);
    setpref('Internet','SMTP_Password',password);
    props = java.lang.System.getProperties;
    props.setProperty('mail.smtp.auth','true');
    props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
    props.setProperty('mail.smtp.socketFactory.port','465');
    % Send the email.  Note that the first input is the address you are sending the email to
    sendmail(recipient_email,'XNAT - SMP Connector job','Hello! Your job is done! Hope for best')
    catch me
        disp(me.message);
    end
end