@ECHO OFF
:: do not run this script manually

:: Check pre-requisites

:: Support for Windows XP
IF NOT DEFINED LOCALAPPDATA (
	SET LOCALAPPDATA="%APPDATA%"
)

:: check if git already exists on the system
IF DEFINED YAWDS_CONF_REQUISITES_GIT (
	:: discover by PATH
	WHERE /Q git
	IF ERRORLEVEL 1 (
		:: if not found, auto discover the git binary
		GOTO DISCOVER_GIT
	)
)

GOTO END

:DISCOVER_GIT
IF EXIST "%LOCALAPPDATA%\Programs\Git\bin\git.exe" (
	SET PATH=%LOCALAPPDATA%\Programs\Git\bin;%PATH%
) ELSE (
  IF EXIST "%PROGRAMFILES%\Git\bin\git.exe" (
    SET PATH=%PROGRAMFILES%\Git\bin;%PATH%
  ) ELSE (
    IF EXIST "%PROGRAMFILES(x86)%\Git\bin\git.exe" (
      SET PATH=%PROGRAMFILES(x86)%\Git\bin;%PATH%
    ) ELSE (
       ECHO ERROR
       ECHO Git is not installed or was not found in the system
       ECHO You must install it to continue
       PAUSE
       EXIT 1
    )
  )
)

:END
