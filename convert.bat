@echo off
title horrible ffmpeg gui thing written as needed by John Storm#7185
cd C:\Users\twitc\Downloads
cls

:legass
SET _audio=a.mp3
ECHO.
ECHO 1. add music to mp4
ECHO 2. convert mp4 to webm for 4chan
ECHO 3. show files
ECHO 4. convert webm to mp4
ECHO 5. convert to gif
ECHO 6. convert to mov
ECHO 7. change framerate
ECHO 8. ram two files toghether
ECHO 9. funny
ECHO x. exit
ECHO d. debog

set choice=
set /p choice=NUMBER IDIOT! : 
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto footass
if '%choice%'=='2' goto headass
if '%choice%'=='3' goto dirshit
if '%choice%'=='d' goto debug
if '%choice%'=='4' goto hedfuk
if '%choice%'=='5' goto gifass
if '%choice%'=='6' goto 7
if '%choice%'=='7' goto fuck
if '%choice%'=='8' goto ram
if '%choice%'=='9' goto funny
if '%choice%'=='x' exit	
ECHO "%choice%" is not valid, try again
ECHO.
goto legass
:funny
echo must be mp4
SET /P normvid= normal video input:
SET /P crass= crash video input:
ECHO.>"C:\Users\twitc\Downloads\garbage.txt"
ECHO file %normvid%>>"C:\Users\twitc\Downloads\garbage.txt"
ECHO file file2_edited.mp4>>"C:\Users\twitc\Downloads\garbage.txt"

ffmpeg -i %crass% -pix_fmt yuv444p file2_edited.mp4

ffmpeg -f concat -i garbage.txt -codec copy output.mp4

del file2_edited.mp4

goto pause
:ram
SET /P filea= file A:
SET /P fileb= file B:
ffmpeg -i %filea% -c copy -bsf:v h264_mp4toannexb -f mpegts input1.ts
ffmpeg -i %fileb% -c copy -bsf:v h264_mp4toannexb -f mpegts input2.ts
ffmpeg -i "concat:input1.ts|input2.ts" -c copy output%random%.mp4
del input1.ts
del input2.ts

goto pause

:fuck
SET /P fps= fps:
SET /P inpussy= file:
ffmpeg -y -i %inpussy% -vf "setpts=1.25*PTS" -r %fps% output.mp4


goto pause
:7

SET /P fuckvariables= file name:
ffmpeg -i %fuckvariables% -acodec copy -vcodec copy -f mov output.mov
echo .
goto pause


:gifass
SET /P cumfuck= file name:
cls
echo file name is : %cumfuck%
echo headass press key to start!
pause>nul
ffmpeg -i %cumfuck% -ss 00:00:00.000 -pix_fmt rgb24 -r 10 -s 320x240 -t 00:00:10.000 output.gif

goto legass

goto pause

ffmpeg -i output.mp4 -vcodec libvpx -acodec libvorbis "%random%.webm"

echo pausing error correction
goto pause

:footass
SET /P _inputname= file name:
cls
echo file name is : %_inputname%
SET /P _audio= specify audio ::default is a.mp3:: :
echo moth! press key to start
pause>nul
ffmpeg -i %_inputname% -i %_audio% -c copy -map 0:v:0 -map 1:a:0 -shortest output.mp4

goto pause

:dirshit
dir
goto legass

:debug
echo printing debug info
set _
echo %_inputname% %_audio%
goto legass

goto pause

:hedfuk

SET /P _inputname= file name:
cls

ffmpeg -fflags +genpts -i %_inputname% -r 24 %_inputname%.mp4


goto pause

:pause
echo press any key to cuntinue
pause>nul
cls
goto legass
