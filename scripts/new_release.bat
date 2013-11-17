@ECHO OFF

SET /P confirm=Do you want to generate a new version? [y/n]: 
IF NOT [%confirm%]==[y] (
	ECHO Canceled
	EXIT 0
)

SET /P version=Enter the new version (e.g: 1.0.0): 
IF [%version%]==[] (
	ECHO You must enter a version. Try again
	pause
	EXIT 1
)

IF NOT EXIST "%~dp0releases" MKDIR "%~dp0releases"

CD "%~dp0..\environment\"

CALL "%~dp0..\environment\stack\tools\7za" -mx7 -o ..\scritps\releaes a yawds-%version%-win32.zip *
