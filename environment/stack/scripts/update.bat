@ECHO OFF

CALL "%~dp0set_env.bat"
CALL "%~dp0read_config.bat"

IF DEFINED YAWDS_CONF_UPDATE_ENABLED (
	IF [%YAWDS_CONF_UPDATE_ENABLED%]==[0] (
		ECHO Environment update is disabled
		EXIT 0
	)
)

IF NOT DEFINED YAWDS_CONF_UPDATE_CHECK_URL (
	ECHO Missing update.check_url config value in environment.ini
	ECHO Cannot new check versions to update
	EXIT 1
)

SET /P confirm_update=Do you want to update %YAWDS_CONF_GENERAL_SHORNAME%? [y/n]: 
IF NOT [%confirm_update%]==[y] (
	ECHO Canceled
	EXIT 0
)



:: TODO

PAUSE
ECHO.

:END
