@ECHO OFF
:: do not run this script manually

SETLOCAL 
:: todo: support for authtentication

IF DEFINED YAWDS_CONF_GENERAL_CONSOLE_COLOR (
	COLOR %YAWDS_CONF_GENERAL_CONSOLE_COLOR%
)

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
	GOTO SET_NOCONFIRM
)
GOTO UPDATE

:SET_NOCONFIRM
SET yawds_from_start=1
GOTO UPDATE

:UPDATE

IF NOT EXIST "%TEMP%" MKDIR "%TEMP%"

IF [%YAWDS_CONF_UPDATE_CHECK_URL_AUTH%]==[1] (
	:: exit if it was called from start.cmd
	IF DEFINED yawds_from_start (
		GOTO END
	)
	ECHO Authentication is required to update
	CALL node "%YAWDS_STACK_PATH%\scripts\node_scripts\prompt\update_auth" "%TEMP%\yawds_update.bat" "update"
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

CALL node "%YAWDS_STACK_PATH%\scripts\node_scripts\ini2batch" "%TEMP%\yawds_latest.ini" "update" > "%TEMP%\yawds_update.bat"
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

IF [%YAWDS_VERSION%]==[%YAWDS_UPDATE_VERSION%] (
	IF DEFINED yawds_from_start (
		GOTO END
	)
	ECHO You are on the latest version: %YAWDS_VERSION%
	ECHO Nothing to update
	GOTO END
)

IF DEFINED yawds_from_start ECHO. 
ECHO There is a new version available: %YAWDS_UPDATE_VERSION%

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

:: require to run from update.cmd (due to windows files blocking issues)
IF DEFINED yawds_from_start (
	ECHO.
	ECHO To proceed with the update, you must run update.cmd
	ECHO.
	PAUSE
	GOTO END
)
 
SET /P confirm_update=Do you want to process with the update? [y/n]: 
IF NOT [%confirm_update%]==[y] (
	ECHO Canceled
	GOTO END
)

ECHO.
ECHO IMPORTANT: 
ECHO You must close all the running processes before continue
ECHO You can use stack\tools\cprocess.exe to see the running processes
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
IF NOT EXIST "%TEMP%\yawds-latest-win32.zip" (
	ECHO File do not exist
	GOTO END
)

ECHO.
ECHO Download completed!
ECHO.

:: backup filename
FOR /F "tokens=* delims= " %%a IN ("%TIME:~0,2%") DO SET hour=%%a
FOR /F "tokens=* delims= " %%a IN ("%TIME:~3,2%") DO SET minute=%%a
SET backup_file=stack-%YAWDS_VERSION%-%date:~6,4%-%date:~3,2%-%date:~0,2%-%hour%%minute%.zip

:: backup the current stack environment
SET /P backup=Do you want to backup the current environment? [Y/n]: 
IF [%backup%]==[y] (
	IF NOT EXIST "%YAWDS_HOME%\backup" MKDIR "%YAWDS_HOME%\backup"
	CD "%YAWDS_HOME%\stack"
	:: create tarball
	CALL 7za -mx7 -y a "%backup_file%" *
	IF NOT ERRORLEVEL 0 (
		ECHO.
		ECHO Error while creating the backup...
		GOTO END_ERROR
	)
	:: move to backup folder
	MOVE /Y "%backup_file%" "%YAWDS_HOME%\backup"
	
	ECHO.
	ECHO Backup created succesfully in:
	ECHO %YAWDS_HOME%\backup\
	ECHO.
	CD "%YAWDS_HOME%"
	PAUSE
)

MOVE /Y "%YAWDS_HOME%\stack" "%YAWDS_HOME%\stack_old" > nul
IF NOT EXIST "%YAWDS_HOME%\stack_old" (
	ECHO.
	ECHO ERROR: cannot write new files
	ECHO Be sure there is not any blocking process still running
	ECHO You can exec stack\tools\cprocess.exe in to see the running processes
	ECHO.
	GOTO END_ERROR
)

ECHO.
ECHO Installing new version...
ECHO.

MKDIR "%YAWDS_HOME%\stack"
CD "%YAWDS_HOME%\stack"

:: install new version
CALL "%YAWDS_HOME%\stack_old\tools\7za.exe" -y e "%TEMP%\yawds-latest-win32.zip"
IF NOT EXIST "%YAWDS_HOME%\stack" (
	ECHO.
	ECHO ERROR: cannot extract and write new files
	ECHO Restoring old stack environment version...
	ECHO.
	MOVE /Y "%YAWDS_HOME%\stack_old" "%YAWDS_HOME%\stack"
	GOTO END_ERROR
)

:: removing old version
DEL /F /Q /S "%YAWDS_HOME%\stack_old"

ECHO.
ECHO %YAWDS_CONF_GENERA_SHORTNAME% was updated succesfully!
ECHO.
GOTO END

:VERSION_ERROR
ECHO Cannot check the latest version: error while reading the ini file
ECHO Cannot update. Try it again

:END
ECHO.
GOTO CLEAN

:END_ERROR
ECHO Cannot update. Try it again

:CLEAN
IF EXIST "%TEMP%\yawds_update.bat" DEL /Q /F "%TEMP%\yawds_update.bat"
IF EXIST "%TEMP%\yawds_latest.ini" DEL /Q /F "%TEMP%\yawds_latest.ini"
IF EXIST "%TEMP%\release_notes" DEL /Q /F "%TEMP%\release_notes"
IF EXIST "%TEMP%\yawds-latest-win32.zip" DEL /Q /F "%TEMP%\yawds-latest-win32.zip"
IF DEFINED yawds_from_start CLS

ENDLOCAL