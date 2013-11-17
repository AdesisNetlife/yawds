@ECHO OFF

IF EXIST "%~dp0..\stack\node\node_modules\bower-auth" GOTO END

CALL "%~dp0config.bat"

:: package versions
SET yo=~1.0.4
SET bower=~1.2.7
SET grunt=~0.1.9

CLS 
ECHO.
ECHO  -----------------------------------------------------
ECHO   Welcome to the Bankia Front environment provisioner
ECHO  -----------------------------------------------------
ECHO.
ECHO This process will install the required packages in the system
ECHO Note that this process may take some minutes...
ECHO.

IF NOT DEFINED USER (
	SET /P USER=Enter your Bankia username: 
)
IF NOT DEFINED PASSWORD (
	SET /P PASSWORD=Enter your password: 
	ECHO.
)

ECHO.
ECHO Installing packages...
ECHO.

:: install Node packages
CALL npm install -g yo@%yo%
CALL npm install -g bower@%bower%
CALL npm install -g grunt-cli@%grunt%

ECHO.
ECHO Provisioning completed!
ECHO.

PAUSE
ECHO. 

:END
