@echo off
echo killing process
taskkill /f /im explorer.exe
echo starting explorer
echo you may now exit
explorer.exe
pause