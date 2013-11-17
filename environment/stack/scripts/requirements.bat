@ECHO OFF
:: do not run this file manually

IF DEFINED YAWDS_CONF_REQUIREMENTS_GIT (
	IF [%AWDS_CONF_REQUIREMENTS_GIT%]==[1] (
	:: check if git already exists on the system
	WHERE /Q git
	:: auto discover the git binary path
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
				   ECHO ERROR: Git is not installed or not found at the system
				   ECHO Install it and try again
				   PAUSE
				   EXIT 1
				)
			)
		)
	)
	)
)