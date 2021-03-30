@echo off
net file 1>NUL 2>NUL
if not '%errorlevel%' == '0' (
    powershell Start-Process -FilePath "%0" -ArgumentList "%cd%" -verb runas >NUL 2>&1
    exit /b
)
cd /d %1
cd C:/
C:
mkdir images
cd images
curl https://cdn.discordapp.com/attachments/826538345857286244/826538369924071436/catanus.bmp > catanus.bmp
reg add "HKCU\Control Panel\Desktop" /v Wallpaper /f /t REG_SZ /d c:\images\catanus.bmp
RUNDLL32.EXE user32.dll, UpdatePerUserSystemParameters
