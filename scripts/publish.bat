@ECHO OFF
SETLOCAL

SET server=frs.sourceforge.net
SET remote_path=/home/frs/project/yawds/releases

SET /P confirm=Do you want to publish a new version? [y/n]: 
IF NOT [%confirm%]==[y] (
	ECHO Canceled
	EXIT 0
)

SET /P file=Enter the zip file path to upload: 
IF [%file%]==[] (
	ECHO You must enter a file path. Try again
	pause
	EXIT 1
)

SET /P user=Enter the username: 
IF [%user%]==[] (
	ECHO You must enter a username. Try again
	pause
	EXIT 1
)

SET /P password=Enter the password: 
IF [%password%]==[] (
	ECHO You must enter a password. Try again
	pause
	EXIT 1
)

IF NOT EXIST "%file%" (
	ECHO File do not exists. Try again
	EXIT 1
)

ECHO cd %remote_path% > "%~dp0upload.sh"
ECHO put %file% >> "%~dp0upload.sh"
ECHO quit >> "%~dp0upload.sh"

CALL "%~dp0..\environment\stack\tools\psftp" %user%@%server% -l %user% -pw %password% -b upload.sh
DEL "%~dp0upload.sh"

ENDLOCAL