@ECHO OFF

SET /P version=Enter the new version (e.g: 1.0.0): 
IF [%version%]==[] (
	ECHO You must enter a version. Try again
	pause
	EXIT 1
)

CD "%~dp0..\environment\"
IF NOT EXIST "%~dp0releases" MKDIR "%~dp0releases"
IF NOT EXIST "%~dp0temp" MKDIR "%~dp0temp"

:: -o "..\scritps\releases"
CALL "%~dp0..\environment\stack\tools\7za" -mx7 a "yawds-%version%-win32.zip" * -x!workspace\ -x!*.zip -x!backup\ -x!config\ -x!config\ -x!packages\ -x!stack\tools\cprocess.cfg -x!thumbs.db -x!stack\scripts\temp -x!stack\provision.lock
MOVE /Y "%~dp0..\environment\yawds-%version%-win32.zip" "%~dp0releases"

ECHO File gererated in: 
ECHO "%~dp0releases"
ECHO.

PAUSE