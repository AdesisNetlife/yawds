@ECHO OFF
:: Do not run this script manually!

IF NOT EXIST "%~dp0..\environment.ini" GOTO NOT_FOUND

IF NOT EXIST "%~dp0temp" MKDIR %~dp0temp

CALL node "%~dp0node_scripts\ini2batch" "%~dp0..\VERSION" > "%~dp0temp\version.bat"
IF ERRORLEVEL 1 GOTO CONFIG_ERROR
CALL "%~dp0temp\version.bat"

CALL node "%~dp0node_scripts\ini2batch" "%~dp0..\environment.ini" "conf" > "%~dp0temp\environment.bat"
IF ERRORLEVEL 1 GOTO CONFIG_ERROR
CALL "%~dp0temp\environment.bat"

GOTO END

:CONFIG_ERROR
ECHO.
ECHO Error while reading ini config file
ECHO Be sure file is well-formed and try again
EXIT 1

:NOT_FOUND
ECHO.
ECHO ERROR: environment.ini not found in: 
ECHO %~dp0..\
ECHO You must create it to continue
EXIT 1

:END
