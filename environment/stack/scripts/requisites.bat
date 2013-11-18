@ECHO OFF
:: do not run this file manually

:: Check pre-requisites

:: check if git already exists on the system
IF DEFINED YAWDS_CONF_REQUISITES_GIT (
	IF [%YAWDS_CONF_REQUISITES_GIT%]==[1] (
	:: discover by PATH 
	WHERE /Q git
	:: if not found, auto discover the git binary
	IF ERRORLEVEL 1 (
		:: Supported in Windows Vista/7/8
		IF DEFINED LOCALAPPDATA (
			SET LOCALAPPDATA="%LOCALAPPDATA%"
		) ELSE (
			:: Windows XP
			SET LOCALAPPDATA="%APPDATA%"
		)

		IF EXIST "%LOCALAPPDATA%\Programs\Git\bin\git.exe" (
		   SET PATH=%LOCALAPPDATA%\Programs\Git\bin;%PATH%
		) ELSE (
			IF EXIST "%PROGRAMFILES%\Git\bin\git.exe" (
				SET PATH=%PROGRAMFILES%\Git\bin;%PATH%
			) ELSE (
				IF EXIST "%PROGRAMFILES(x86)%\Git\bin\git.exe" (
					SET "PATH=%PROGRAMFILES(x86)%\Git\bin;%PATH%"
				) ELSE (
				   ECHO ERROR: 
				   ECHO Git is not installed or was not found in the system
				   ECHO You must install it to continue
				   PAUSE
				   EXIT 1
				)
			)
		)
	)
	)
)