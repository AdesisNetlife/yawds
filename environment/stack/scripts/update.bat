@ECHO OFF
SETLOCAL 

CALL "%~dp0set_env.bat"
CALL "%~dp0env_config.bat"

IF [%YAWDS_CONF_UPDATE_ENABLED%]==[0] (
	ECHO Environment update is disabled
	EXIT 0
)

IF NOT DEFINED YAWDS_CONF_UPDATE_CHECK_URL (
	ECHO Missing update.check_url config value in environment.ini
	ECHO Cannot checkout for new versions
	EXIT 1
)

SET /P confirm_update=Do you want to check for updates? [y/n]: 
IF NOT [%confirm_update%]==[y] (
	ECHO Canceled
	PAUSE
	EXIT 0
)

IF NOT EXIST "%YAWDS_STACK_PATH%\scripts\temp\" MKDIR "%YAWDS_STACK_PATH%\scripts\temp\"
IF EXIST "%YAWDS_STACK_PATH%\scripts\temp\latest_version.ini" (
	DEL /F /Q "%YAWDS_STACK_PATH%\scripts\temp\latest_version.ini"
)

:: TODO: do it from node script ;)
IF [%YAWDS_CONF_UPDATE_CHECK_URL_AUTH%]==[1] (
	ECHO Authentication is required to check updates
	SET /P auth_user=Enter your user name: 
	SET /p auth_password=Enter your password: 
	CALL wget --http-user=%auth_user% --http-passwd=%auth_password% -O "%~dp0temp\latest_version.ini" "https://bitbucket.org/adesisnetlife/repsol-proyecto-f-nix-intranet/raw/1de39c084d0a96e5a4e3f1f8bc4361d460f96457/.bowerrc"
) ELSE (
	CALL wget -O "%~dp0temp\latest_version.ini" "https://bitbucket.org/adesisnetlife/repsol-proyecto-f-nix-intranet/raw/1de39c084d0a96e5a4e3f1f8bc4361d460f96457/.bowerrc"
)
IF NOT ERRORLEVEL 0 (
	ECHO Cannot check the remote version: %ERRORLEVEL%
	EXIT 1
)

CALL node "%~dp0node_scripts\ini2batch" "%~dp0temp\latest_version.ini" "update" > "%~dp0temp\latest_version.bat"
CALL "%~dp0temp\latest_version.bat"
IF NOT ERRORLEVEL 0 GOTO CONFIG_ERROR

IF NOT DEFINED YAWDS_UPDATE_VERSION (
	ECHO Cannot check the latest version, value is empty
	ECHO.
	GOTO END
)

IF NOT DEFINED YAWDS_UPDATE_DOWNLOAD (
	ECHO Version download URL not defined. It is required 
	ECHO Can't update
	ECHO.
	GOTO END
)

IF [%YAWDS_VERSION%]==[%YAWDS_UPDATE_VERSION%] (
	ECHO You are on the latest version: %YAWDS_VERSION%
	ECHO Nothing to update
	ECHO.
	GOTO END
)

ECHO.
ECHO There is a new version available: %YAWDS_UPDATE_VERSION%
ECHO.

IF DEFINED YAWDS_UPDATE_RELEASE_NOTES (
	ECHO "Release notes: %YAWDS_UPDATE_RELEASE_NOTES%"
	ECHO.
)
IF DEFINED YAWDS_UPDATE_RELEASE_NOTES_URL (
	DEL /F /Q "%~dp0temp\release_notes"
	IF [%YAWDS_CONF_UPDATE_CHECK_URL_AUTH%]==[1] (
		CALL wget -q "--http-user=%auth_user%" "--http-passwd=%auth_password%" -O "%~dp0temp\release_notes" "%YAWDS_UPDATE_RELEASE_NOTES_URL%"
	) ELSE (
		CALL wget -q -O "%~dp0temp\release_notes" "%YAWDS_UPDATE_RELEASE_NOTES_URL%"
	)
	IF EXIST "%~dp0temp\release_notes" (
		ECHO Release notes:
		TYPE "%~dp0temp\release_notes"
	)
)

SET /P confirm_update=Do you want to process with the update? [y/n]: 
IF NOT [%confirm_update%]==[y] (
	ECHO Canceled
	PAUSE
	EXIT 0
)

ECHO.
ECHO IMPORTANT: you must close all the running processes before continue
ECHO.

PAUSE

ECHO Downloading latest version...

IF [%YAWDS_UPDATE_DOWNLOAD_AUTH%]==[1] SET require_auth=1
IF [%YAWDS_CONF_UPDATE_CHECK_URL_AUTH%]==[1] SET require_auth=1

IF [%require_auth%]==[1] (
	CALL wget "--http-user=%auth_user%" "--http-passwd=%auth_password%" -O "%TEMP%\yawds-latest-win32.zip" "%YAWDS_UPDATE_DOWNLOAD%"
) ELSE (
	CALL wget -O "%TEMP%\yawds-latest-win32.zip" "%YAWDS_UPDATE_DOWNLOAD%"
)
IF NOT ERRORLEVEL 0 (
	ECHO Download error.
	GOTO END
)

ECHO ERROR:%ERRORLEVEL% 

ECHO Download completed!
ECHO.

SET /P backup=Do you want to backup? [Y/n]: 
IF [%backup%]==[y] (
	ECHO Backing files...

)

:VERSION_ERROR
ECHO Cannot check the latest version: error while reading the ini file

:END
PAUSE

ENDLOCAL