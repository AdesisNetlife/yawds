@ECHO OFF
:: Do not run this file manually!

IF EXIST "%YAWDS_HOME%\config\user.ini" GOTO END 

IF NOT EXIST "%YAWDS_HOME%\config" MKDIR "%YAWDS_HOME%\config\user.ini"

ECHO.
IF DEFINED YAWDS_CONF_INSTALL_MESSAGE (
	ECHO %YAWDS_CONF_INSTALL_MESSAGE% 
) ELSE (
	ECHO Welcome to %YAWDS_CONF_GENERAL_NAME% %YAWDS_VERSION%
)
ECHO.
ECHO This is the first time you run the environment
ECHO A setup process is required, this may take some minutes
ECHO.
pause
ECHO.

:: general auth credentials
CALL node "%~dp0node_scripts\prompt\auth" "%YAWDS_HOME%\config\user.ini"
:: proxy config and authentication
CALL node "%~dp0node_scripts\prompt\proxy" "%YAWDS_HOME%\config\user.ini"

IF NOT EXIST "%YAWDS_HOME%\config\user.ini" ECHO. > "%YAWDS_HOME%\config\user.ini"

ECHO.
ECHO Environment setup success!
ECHO.

:END