--1.启用Database Mail扩展存储过程
sp_configure 'show advanced options', 1
GO
RECONFIGURE
GO
sp_configure 'Database Mail XPs', 1
GO
RECONFIGURE
GO
sp_configure 'show advanced options', 0
GO
RECONFIGURE
GO
 
--2.添加account
exec msdb..sysmail_add_account_sp
        @account_name            = 'zhanghao' --邮件帐户名称SQL Server 使用
       ,@email_address           = 'zhanghao@126.com' --发件人邮件地址
       ,@mailserver_name         = 'smtp.126.com'        --邮件服务器地址
       ,@mailserver_type         = 'SMTP'                --邮件协议SQL 2005只支持SMTP
       ,@port                    = 25                    --邮件服务器端口
       ,@username                = 'zhanghao' --用户名
       ,@password                = 'mima' --密码
        
--3.添加profile
exec msdb..sysmail_add_profile_sp
@profile_name = 'dba_profile'-- profile 名称
   ,@description  = 'dba mail profile'-- profile 描述
   ,@profile_id   = null
    
--4.映射account和profile
exec msdb..sysmail_add_profileaccount_sp  
@profile_name    = 'dba_profile'-- profile 名称
   ,@account_name    = 'zhanghao'-- account 名称
   ,@sequence_number = 1-- account 在profile中顺序
  
--5.1发送文本邮件
exec msdb..sp_send_dbmail
@profile_name =  'dba_profile'
   ,@recipients   =  'xxx@qq.com'
   ,@subject      =  'SQL Server邮件测试'
   ,@body         =  '内容啊'
   ,@body_format  =  'TEXT'
    
--5.2发送附件
EXEC sp_send_dbmail
    @profile_name = 'dba_profile',
    @recipients = 'xxx@qq.com',
    @subject = '这是附件',
@file_attachments ='G:\乱七八糟\sql.txt'
 
--5.3发送查询结果
EXEC sp_send_dbmail
    @profile_name = 'dba_profile',
    @recipients = 'xxx@qq.com',
    @subject = '这是查询',
@query='select * from test.dbo.apo_city'
    
--6.查看邮件发送情况
select * from sysmail_allitems
select * from sysmail_mailitems
select * from sysmail_event_log
 
--7.删除邮件配置
Exec msdb..sysmail_delete_profileaccount_sp  
@profile_name = 'dba_profile',
    @account_name = 'zhanghao'
Exec msdb..sysmail_delete_profile_sp
@profile_name = 'dba_profile'
Exec msdb..sysmail_delete_account_sp
@account_name ='zhanghao'