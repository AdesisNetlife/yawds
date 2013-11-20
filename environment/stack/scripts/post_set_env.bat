@ECHO OFF
:: do not run this script manually

IF [%YAWDS_PKG_PROVISION_ENABLED%]==[0] GOTO END

:: auto discover binaries directories for aditional packages
:: useful to automatically add them to be path accesible
IF EXIST "%YAWDS_HOME%\packages" (
	SET CWD=%CD%
	CD "%YAWDS_HOME%\packages"
	FOR /D %%i IN (*.*) DO (
		IF NOT [%%i]==[ruby] (
			IF EXIST "%YAWDS_HOME%\packages\%%i\bin" (
				SET PATH=%%YAWDS_HOME%\packages\%%i\bin%;%PATH%
			)
		)
	)
	CD "%CWD%"
)

:END