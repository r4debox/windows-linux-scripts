@ECHO OFF
:: Check command line arguments and Windows version
IF [%1]==[] GOTO Syntax
IF [%1]==[/?] GOTO Syntax
IF [%2]==[/?] GOTO Syntax
IF NOT [%3]==[] GOTO Syntax
IF NOT [%2]==[] IF /I NOT [%1]==[-DEBUG] IF /I NOT [%2]==[-DEBUG] GOTO Syntax
IF NOT "%OS%"=="Windows_NT" GOTO Syntax
 
SETLOCAL
:: Initialize local variables
SET Dir=
SET Host=
SET IPDec=
SET IPHex=
SET Manual=
SET Prot=
SET URL=
 
:: Parse command line arguments
ECHO. %* | FIND /I " -DEBUG " >NUL
IF ERRORLEVEL 1 (SET DEBUG=0) ELSE (SET DEBUG=1)
IF %DEBUG%==0 (
	SET URL=%~1
) ELSE (
	IF /I [%1]==[-DEBUG] SET URL=%~2
	IF /I [%2]==[-DEBUG] SET URL=%~1
)
IF NOT DEFINED URL GOTO Syntax
ECHO "%URL%" | FIND /I "tp://" >NUL
IF NOT ERRORLEVEL 1 FOR /F "tokens=1* delims=:" %%A IN ("%URL%") DO (
	SET Prot=%%A
	SET URL=%%B
)
IF DEFINED Prot (
	SET Prot=%Prot%://
	SET URL=%URL:~2%
)
FOR /F "tokens=1* delims=/" %%A IN ("%URL%") DO (SET Host=%%A&SET Dir=%%B)
IF DEFINED Dir (
	SET Dir=/%Dir%
) ELSE (
	ECHO."%URL%" | FIND "/" >NUL
	IF NOT ERRORLEVEL 1 SET Dir=/%Dir%
)
 
:: Check if specified host name is available
FOR /F "tokens=2 delims=[]" %%A IN ('PING %Host% -n 1 2^>NUL') DO SET IPHex=%%A
IF NOT DEFINED IPHex (
	ECHO Host name invalid or host not available
	GOTO:EOF
)
 
:: Call subroutine to convert IP address to decimal number
FOR /F "tokens=1-4 delims=." %%A IN ("%IPHex%") DO CALL :Hex2Dec %%A %%B %%C %%D
 
:: Display intermediate results if -DEBUG switch was used
IF %DEBUG%==1 (
	ECHO.
	SET URL
	SET Prot
	SET Host
	SET IPHex
	SET IPDec
	SET Dir
	ECHO.
	IF DEFINED Manual (
		ECHO Due to limitations in integer size in batch files, you will need to add
		ECHO 2147483648 to IPDec manually
	)
)
 
:: Message if decimal IP address exceeds integer limit for batch files
IF DEFINED Manual SET IPDec=[ %IPDec% + 2147483648 ]
 
:: Display the result
ECHO.
ECHO Obscured URL examples:
ECHO.
ECHO    %Prot%%IPDec%%Dir%
ECHO    %Prot%fake.host@%IPDec%%Dir%
 
:: Display another warning message if decimal number exceeds integer limit
IF DEFINED Manual (
	ECHO.
	ECHO Please replace "%IPDec%" with the result of the addition,
	ECHO without the brackets, spaces or quotes!
)
 
:: Done
ENDLOCAL
GOTO:EOF
 
 
:Hex2Dec
:: Check if IP address exceeds integer limit for batch files
IF %1 LSS 128 (
	SET First=%1
) ELSE (
	SET /A First = %1 - 128
	SET Manual=1
)
:: Convert IP address to decimal number
SET /A IPDec = (( %First% * 256 + %2 ) * 256 + %3 ) * 256 + %4
GOTO:EOF
 
 
:Syntax
ECHO Obscure.bat,  Version 1.00 for Windows NT
ECHO Obscure the specified URL by converting the host name to a decimal IP address
ECHO and by adding a hostname -- either vake or valid -- as a fake login name.
ECHO.
ECHO Usage:  OBSCURE.BAT  url  [ -DEBUG ]
ECHO Where:  "url"   can be any valid URL, host name or IP address
ECHO         -DEBUG  displays intermediate results
ECHO.
ECHO Explanation: Let's take the fictional http://somehost.com/sources/ and let's
ECHO assume somehost.com's IP address is 1.2.3.4. The decimal representation of the
ECHO IP address is: 1 * 256**3 + 2 * 256**2 + 3 * 256 + 4 = 16909060
ECHO Try pinging 16909060, it will show 1.2.3.4 as the address being pinged. So the
ECHO URL could also be written as http://16909060/sources/. Any URL may be preceded
ECHO with a user ID followed by an @. So we can further obscure the URL by adding a
ECHO fake host name: http://fake.host@16909060/ still points to http://somehost.com/
ECHO.
ECHO Notes:  [1] Browser security settings may block use of decimal addresses
ECHO         [2] Due to the integer size limit in batch files, you will need to add
ECHO             2147483648 manually to the displayed decimal IP address for IP
ECHO             addresses 128.0.0.0 and up; if so, a message will be displayed.
ECHO.