@ECHO OFF
SETLOCAL 
:: todo: support for authtentication

CALL "%~dp0set_env.bat"
CALL "%~dp0env_config.bat"

IF [%YAWDS_CONF_UPDATE_ENABLED%]==[0] (
	ECHO Environment update is disabled
	GOTO END
)

IF NOT DEFINED YAWDS_CONF_UPDATE_CHECK_URL (
	ECHO Missing update.check_url config value in environment.ini
	ECHO Cannot checkout for new versions
	GOTO END
)

IF [%1]==[--confirm] (
	GOTO UPDATE
)
SET yawds_from_start=1

SET /P confirm_update=Do you want to check for updates? [y/n]: 
IF NOT [%confirm_update%]==[y] (
	ECHO Canceled
	GOTO END
)

:UPDATE

IF NOT EXIST "%TEMP%" MKDIR "%TEMP%"

IF [%YAWDS_CONF_UPDATE_CHECK_URL_AUTH%]==[1] (
	:: exit if it was called from start.cmd
	IF DEFINED yawds_from_start (
		GOTO END
	)
	ECHO Authentication is required to update
	CALL node "%~dp0node_scripts\prompt\update_auth" "%TEMP%\yawds_update.bat" "update"
	IF NOT ERRORLEVEL 0 (
		ECHO Error setting authtentication credentials
		GOTO END_ERROR
	)
	GOTO CHECK_AUTH_HTTP
) ELSE (
	GOTO CHECK_HTTP
)

:CHECK_AUTH_HTTP
CALL "%TEMP%\yawds_update.bat"
IF NOT DEFINED YAWDS_UPDATE_USER (
	ECHO Authentication required
	GOTO END_ERROR
)
CALL wget -q -nv "--http-user=%YAWDS_UPDATE_USER%" "--http-passwd=%YAWDS_UPDATE_PASSWORD%" -O "%TEMP%\yawds_latest.ini" "%YAWDS_CONF_UPDATE_CHECK_URL%"
GOTO CONTINUE

:CHECK_HTTP
CALL wget -q -nv -O "%TEMP%\yawds_latest.ini" "%YAWDS_CONF_UPDATE_CHECK_URL%" 
	
:CONTINUE
IF NOT ERRORLEVEL 0 (
	ECHO Cannot check out remote version for updates
	ECHO Be sure you have network connection and try again
	GOTO END_ERROR
)

CALL node "%~dp0node_scripts\ini2batch" "%TEMP%\yawds_latest.ini" "update" > "%TEMP%\yawds_update.bat"
CALL "%TEMP%\yawds_update.bat"
IF NOT ERRORLEVEL 0 GOTO CONFIG_ERROR

IF NOT DEFINED YAWDS_UPDATE_VERSION (
	ECHO Cannot check the latest version
	GOTO END_ERROR
)

IF NOT DEFINED YAWDS_UPDATE_DOWNLOAD (
	ECHO Download URL not defined. Cannot update
	GOTO END
)

IF [%YAWDS_VERSION%]==[0.1.2] (
	ECHO You are on the latest version: %YAWDS_VERSION%
	ECHO Nothing to update
	GOTO END
)

ECHO.
ECHO There is a new version available: %YAWDS_UPDATE_VERSION%
ECHO.

IF DEFINED YAWDS_UPDATE_RELEASE_NOTES (
	ECHO.
	ECHO Release notes: 
	ECHO "%YAWDS_UPDATE_RELEASE_NOTES%"
	ECHO.
)
IF DEFINED YAWDS_UPDATE_RELEASE_NOTES_URL (
	IF [%YAWDS_CONF_UPDATE_CHECK_URL_AUTH%]==[1] (
		CALL wget -q "--http-user=%YAWDS_UPDATE_USER%" "--http-passwd=%YAWDS_UPDATE_PASSWORD%" -O "%TEMP%\release_notes" %YAWDS_UPDATE_RELEASE_NOTES_URL%
	) ELSE (
		CALL wget -q -O "%TEMP%\release_notes" "%YAWDS_UPDATE_RELEASE_NOTES_URL%"
	)
	IF EXIST "%TEMP%\release_notes" (
		ECHO.
		ECHO Release notes
		ECHO ---------------------------------------------
		TYPE "%TEMP%\release_notes"
		ECHO.
		ECHO ---------------------------------------------
		ECHO.
	)
)

SET /P confirm_update=Do you want to process with the update? [y/n]: 
IF NOT [%confirm_update%]==[y] (
	ECHO Canceled
	GOTO END
)

ECHO.
ECHO IMPORTANT: 
ECHO You must close all the running processes before continue
ECHO.

PAUSE

ECHO Downloading latest version...

IF [%YAWDS_UPDATE_DOWNLOAD_AUTH%]==[1] SET require_auth=1
IF [%YAWDS_CONF_UPDATE_CHECK_URL_AUTH%]==[1] SET require_auth=1

IF [%require_auth%]==[1] (
	CALL wget --progress=bar "--http-user=%YAWDS_UPDATE_USER%" "--http-passwd=%YAWDS_UPDATE_PASSWORD%" -O "%TEMP%\yawds-latest-win32.zip" "%YAWDS_UPDATE_DOWNLOAD%"
) ELSE (
	CALL wget --progress=bar -O "%TEMP%\yawds-latest-win32.zip" "%YAWDS_UPDATE_DOWNLOAD%"
)
IF NOT ERRORLEVEL 0 (
	ECHO Download error
	GOTO END
)

ECHO.
ECHO Download completed!
ECHO.

SET /P backup=Do you want to backup the current environment? [Y/n]: 
IF [%backup%]==[y] (
	ECHO Backing files...

)

:VERSION_ERROR
ECHO Cannot check the latest version: error while reading the ini file

:END
ECHO.
IF EXIST output.log DEL /F /Q output.log
GOTO CLEAN

:END_ERROR
ECHO Cannot update

:CLEAN
IF EXIST "%TEMP%\yawds_update.bat" DEL /Q /F "%TEMP%\yawds_update.bat"
IF EXIST "%TEMP%\yawds_latest.ini" DEL /Q /F "%TEMP%\yawds_latest.ini"
IF EXIST  "%TEMP%\release_notes" DEL /Q /F "%TEMP%\release_notes"
IF DEFINED yawds_from_start CLS

ENDLOCAL