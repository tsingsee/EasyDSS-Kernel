@set dir=%~dp0
@echo %dir%
@call powershell -Command "(gc %dir%EasyDSS-service.xml) -replace '<logpath>.*</logpath>', '<logpath>%dir%logs</logpath>' | Out-File %dir%EasyDSS-service.xml"
@call powershell -Command "(gc %dir%EasyDSS-service.xml) -replace '<executable>.*</executable>', '<executable>%dir%EasyDSS.exe</executable>' | Out-File %dir%EasyDSS-service.xml"
@call powershell -Command "(gc %dir%EasyDSS-service.xml) -replace '<startarguments>.*</startarguments>', '<startarguments>-p %dir%</startarguments>' | Out-File %dir%EasyDSS-service.xml"
@call powershell -Command "(gc %dir%EasyDSS-service.xml) -replace '<stopexecutable>.*</stopexecutable>', '<stopexecutable>%dir%EasyDSS.exe</stopexecutable>' | Out-File %dir%EasyDSS-service.xml"
@call powershell -Command "(gc %dir%EasyDSS-service.xml) -replace '<stoparguments>.*</stoparguments>', '<stoparguments>-p %dir% -s stop</stoparguments>' | Out-File %dir%EasyDSS-service.xml"

%dir%luajit.exe %dir%scripts/run.lua

%dir%EasyDSS-service.exe install

sc failure EasyDSS reset= 0 actions= restart/0
sc config EasyDSS type= interact type= own
net start EasyDSS
pause