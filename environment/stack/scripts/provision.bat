@ECHO OFF
:: do not fun this script manually

CLS 
ECHO.
ECHO %YAWDS_CONF_GENERAL_NAME% provisioner
ECHO.
ECHO This process will install the selected packages in the system
ECHO Note that this process may take some minutes...
ECHO.

ECHO Installing packages...
ECHO.

:: todo
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
