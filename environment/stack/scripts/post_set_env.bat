@ECHO OFF
:: do not run this script manually

:: IF [%YAWDS_PKG_PROVISION_ENABLED%]==[0] GOTO END

:: auto discover binaries directories for aditional packages
:: useful to automatically add them to be path accesible

IF EXIST "%YAWDS_HOME%\packages" (
	GOTO DISCOVER_BIN
)

GOTO END

:DISCOVER_BIN
SET CWD="%CD%"
CD "%YAWDS_HOME%\packages" > nul

FOR /F "delims=" %%i in ('dir /a:d /b') DO (
	IF NOT [%%i]==[ruby] (
		:: drain the PATH variable with the installed packages
		IF EXIST "%YAWDS_HOME%\packages\%%i\bin" (
			SET PATH=%YAWDS_HOME%\packages\%%i\bin%;%PATH%
		)
		:: load package-specific environment variables
		IF EXIST "%YAWDS_HOME%\packages\%%i\_setenv.bat" (
			CALL "%YAWDS_HOME%\packages\%%i\_setenv.bat"
		)
	)
)

CD "%CWD%" > nul

:END