@ECHO OFF
:: Do not run this script manually!

IF NOT EXIST "%~dp0..\..\config\user.ini" GOTO END

CALL node "%~dp0node_scripts\set_proxy" "%~dp0..\..\config\user.ini" > "%~dp0temp\proxy.bat"
IF ERRORLEVEL 1 GOTO CONFIG_ERROR
CALL "%~dp0temp\proxy.bat"

CALL npm config set prefix "%~dp0..\stack\node" --global
CALL npm config set strict-ssl false --global

GOTO END

IF DEFINED GIT_USERNAME (
	CALL git config --global user.name "%GIT_USERNAME%"
	CALL git config --global user.email "%GIT_EMAIL%"
)

:: Git config
CALL git config --global http.sslVerify false

:END
