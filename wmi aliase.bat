@ECHO OFF
IF NOT "%OS%"=="Windows_NT" GOTO Syntax
IF NOT  "%~2"==""           GOTO Syntax
IF      "%~1"=="/?"         GOTO Syntax
WMIC /?  >NUL  2>&1   ||    GOTO Syntax
 
:: No command line argument: list all aliases and their true class names, sorted by alias
IF "%~1"=="" (
	"%~f0" /SORT | SORT
	GOTO:EOF
)
 
IF /I "%~1"=="/SORT" (
	REM List all aliases and their true class names
	Call :List
) ELSE (
	REM Show specified alias and its true class name
	CALL :List %1
)
 
GOTO:EOF
 
 
:List
SETLOCAL ENABLEDELAYEDEXPANSION
(ECHO ALIAS:                      WMI CLASS NAME:) 1>&2
(ECHO.======                      ===============) 1>&2
FOR /F "skip=1 tokens=1,5" %%A IN ('WMIC ALIAS %1 Get FriendlyName^,Target') DO (
	REM Append 20 spaces to alias
	SET Output=%%A                    
	REM Chop alias plus spaces at 20 characters
	SET Output=!Output:~0,20!
	REM Append class name
	SET Output=!Output!        %%B
	ECHO.!Output!
)
ENDLOCAL
GOTO:EOF
 
 
:Syntax
ECHO.
ECHO WMIAlias.bat,  Version 1.00 for Windows XP professional and later
ECHO Return the class name for the specified WMIC alias, or all if none specified
ECHO.
ECHO Usage:  WMIALIAS  [ alias ]
ECHO.
ECHO Where:  alias     is a WMIC alias, e.g. "bios" for the "Win32_BIOS" class
ECHO.
ECHO Note:   If no alias is specified, all WMIC aliases and their class names will
ECHO         be listed, sorted by alias name.
 
IF NOT "%OS%"=="Windows_NT" GOTO :SkippedIfNotNT
ECHO         To sort the output by class name, use the following command:
ECHO         WMIALIAS  ^|  SORT  /+20
:SkippedIfNotNT
 
ECHO.
ECHO Written by Rob van der Woude
ECHO http://www.robvanderwoude.com
 
IF "%OS%"=="Windows_NT" EXIT /B 1
 