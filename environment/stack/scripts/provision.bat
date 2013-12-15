@ECHO OFF
:: do not run this script manually

IF NOT EXIST "%YAWDS_STACK_PATH%\packages.ini" GOTO END
IF [%YAWDS_PKG_PROVISION_ENABLED%]==[0] GOTO END

:: todo: isolate node and ruby packages verification
IF EXIST "%YAWDS_STACK_PATH%\provision.lock" (
	IF NOT [%YAWDS_PKG_PROVISION_KEEP_UPDATE%]==[1] (
		GOTO END
	)
)

ECHO %YAWDS_CONF_GENERAL_SHORTNAME% packages provisioning
ECHO.
IF NOT EXIST "%YAWDS_STACK_PATH%\provision.lock" (
	ECHO Package provisining process
	ECHO coffee time! this may take some minutes...
	ECHO.
)

CALL node "%~dp0node_scripts\install_packages" "%YAWDS_STACK_PATH%\packages.ini" > "%~dp0temp\install_packages.bat"
IF NOT ERRORLEVEL 0 GOTO CONFIG_ERROR

CALL "%~dp0temp\install_packages.bat"
IF NOT ERRORLEVEL 0 (
	ECHO WARNING: provisioning failed, unexpected exit code
	ECHO Cannot install packages on the system
	ECHO Be sure you are properly connected to the Internet

	SET /P cancel=Do you want to cancel the process and try again later? [Y/n]: 
	IF NOT [%cancel%]==[n] (
		ECHO Canceled
		EXIT 0
	)
)

ECHO provisioned=true > "%YAWDS_STACK_PATH%\provision.lock"

ECHO.
ECHO Provisioning completed!
ECHO Packages was installed in:
ECHO %YAWDS_HOME%\%YAWDS_PKG_INSTALL_DIR%
ECHO.

PAUSE
GOTO END

:CONFIG_ERROR
ECHO ERROR: cannot packages.ini fail
ECHO Provisioning not completed

:END
