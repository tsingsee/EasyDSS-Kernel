set dir=%~dp0

%dir%luajit.exe %dir%scripts/run.lua

start %dir%EasyDSS.exe
echo easydss server start success!

pause