@echo off  
:nig
set /p IMAGE= image: 
set /p hex= HEX or color name value to make transparent: 
set /p fuzz= fuzz amount 2 4 6 for removing crust Must have percent: 
convert ( %IMAGE% ( +clone -channel RGBA -blur 0x1 ) -compose DstOver -composite ^
	 ( +clone -channel RGBA -blur 0x1 ) -compose DstOver -composite ^
	 ( +clone -channel RGBA -blur 0x1 ) -compose DstOver -composite ^
	 ( +clone -channel RGBA -blur 0x1 ) -compose DstOver -composite ^
	 ( +clone -channel RGBA -blur 0x1 ) -compose DstOver -composite ^
	 ( +clone -channel RGBA -blur 0x1 ) -compose DstOver -composite ^
	 ( +clone -channel RGBA -blur 0x1 ) -compose DstOver -composite ^
	 ( +clone -channel RGBA -blur 0x1 ) -compose DstOver -composite ^
	 ( +clone -channel RGBA -blur 0x1 ) -compose DstOver -composite ^
	 ( +clone -channel RGBA -blur 0x2 ) -compose DstOver -composite ^
	 ( +clone -channel RGBA -blur 0x2 ) -compose DstOver -composite ^
	 ( +clone -channel RGBA -blur 0x2 ) -compose DstOver -composite ^
	 ( +clone -channel RGBA -blur 0x2 ) -compose DstOver -composite ^
	 ( +clone -channel RGBA -blur 0x2 ) -compose DstOver -composite ^
	 ( +clone -channel RGBA -blur 0x3 ) -compose DstOver -composite ^
	 ( +clone -channel RGBA -blur 0x3 ) -compose DstOver -composite ^
	 ( +clone -channel RGBA -blur 0x3 ) -compose DstOver -composite ^
	 ( +clone -channel RGBA -blur 0x4 ) -compose DstOver -composite ^
	 ( +clone -channel RGBA -blur 0x4 ) -compose DstOver -composite ^
	 ( +clone -channel RGBA -blur 0x5 ) -compose DstOver -composite ^
	 ( +clone -channel RGBA -blur 0x5 ) -compose DstOver -composite ^
	 ( +clone -channel RGBA -blur 0x5 ) -compose DstOver -composite ^
	 ( +clone -channel RGBA -blur 0x5 ) -compose DstOver -composite ^
	 ( +clone -channel RGBA -blur 0x5 ) -compose DstOver -composite ^
	 ( +clone -channel RGBA -blur 0x5 ) -compose DstOver -composite ) %IMAGE% -compose CopyOpacity -composite janet%IMAGE%


	convert janet%IMAGE% -fuzz %fuzz% -transparent "%hex%" transparent.png
	
del janet%IMAGE% 
pause
goto nig