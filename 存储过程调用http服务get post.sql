--sql 服务器设置

--启动 OLE Automation Procedures
sp_configure 'show advanced options', 1;   --此选项用来显示sp_configure系统存储过程高级选项，当其值为1时，可以使用sp_configure列出高级选项。默认为0；
GO
RECONFIGURE WITH OVERRIDE;
GO
sp_configure 'Ole Automation Procedures', 1;  --此选项可指定是否可以在Transact-SQL批处理中实例化OLEAutomation 对象。
GO
RECONFIGURE WITH OVERRIDE;
GO
EXEC sp_configure 'Ole Automation Procedures';  --查看OLE Automation Procedures的当前设置。
GO


--存储过程调用示例

declare @ServiceUrl as varchar(1000)
set @ServiceUrl = 'http://192.16.1.2:9905/clmsApi/thirdInterfaceDel/insertDatas'
DECLARE @data varchar(max);
--发送数据
set @data='{  
    "evtcode": "BD_DOC_04.SC0001.EV_DOC004",
    "input": {    "jk_type":1,
                "jzlb":2,
                "details": '+@jsonDatas+'
    }
}
    '                   
Declare @Object as Int
Declare @ResponseText AS  varchar(8000)   ;   
print 1;   
Exec sp_OACreate 'Msxml2.ServerXMLHTTP.3.0', @Object OUT;
print 2;
Exec sp_OAMethod @Object, 'open', NULL, 'POST',@ServiceUrl,'false'
print 3;
Exec sp_OAMethod @Object, 'setRequestHeader', NULL, 'Content-Type','application/json'
print 4;
Exec sp_OAMethod @Object, 'send', NULL, @data --发送数据
print 5;
Exec sp_OAMethod @Object, 'responseText', @ResponseText OUTPUT
EXEC sp_OAGetErrorInfo @Object --异常输出
print  @ResponseText
Exec sp_OADestroy @Object