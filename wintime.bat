@echo off
net file 1>NUL 2>NUL
if not '%errorlevel%' == '0' (
    powershell Start-Process -FilePath "%0" -ArgumentList "%cd%" -verb runas >NUL 2>&1
    exit /b
)
cd /d %1
net stop w32time
w32tm /unregister
w32tm /register
net start w32time
w32tm /resync
pause
