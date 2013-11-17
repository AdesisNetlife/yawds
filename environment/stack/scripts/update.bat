@ECHO OFF

ECHO.
ECHO This process will update the whole environment
ECHO.

CALL "%~dp0set_env.bat"
CALL "%~dp0read_config.bat"

SET /P confirm_update=Do you want to proceed with the update? [y/n]: 
IF NOT [%confirm_update%]==[y] (
	ECHO Canceled
	EXIT 0
)

:: TODO

PAUSE
ECHO.