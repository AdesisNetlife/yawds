@ECHO OFF
:: Do not run this script manually!

IF EXIST "%YAWDS_HOME%\config\user.ini" (
	:: set proxy environment variables, if defined in user.ini 
	::CALL node "%~dp0node_scripts\set_proxy" "%YAWDS_HOME%\config\user.ini" > "%~dp0temp\proxy.bat"
	::IF ERRORLEVEL 1 GOTO CONFIG_ERROR
	::CALL "%~dp0temp\proxy.bat"

	:: set auth variables, if defined in user.ini
	CALL node "%~dp0node_scripts\set_user_vars" "%YAWDS_HOME%\config\user.ini" "auth" > "%~dp0temp\user_auth.bat"
	IF ERRORLEVEL 1 GOTO CONFIG_ERROR
	CALL "%~dp0temp\user_auth.bat"
)

:: set proxy environment variables, if defined in user.ini
CALL node "%~dp0node_scripts\set_proxy" "%YAWDS_HOME%\config\user.ini" > "%~dp0temp\proxy.bat"
IF ERRORLEVEL 1 GOTO CONFIG_ERROR
CALL "%~dp0temp\proxy.bat"

:: packages installation config
IF NOT DEFINED YAWDS_PKG_INSTALL_DIR (
  SET YAWDS_PKG_INSTALL_DIR=packages
)
IF NOT EXIST "%YAWDS_HOME%\%YAWDS_PKG_INSTALL_DIR%" (
	MKDIR "%YAWDS_HOME%\%YAWDS_PKG_INSTALL_DIR%"
)

:: npm specific
IF NOT EXIST "%YAWDS_HOME%\%YAWDS_PKG_INSTALL_DIR%\node" (
	MKDIR "%YAWDS_HOME%\%YAWDS_PKG_INSTALL_DIR%\node"
)

CALL npm config set --global userconfig "%YAWDS_HOME%\%YAWDS_PKG_INSTALL_DIR%\.npmrc" 
CALL npm config set --global prefix "%YAWDS_HOME%\%YAWDS_PKG_INSTALL_DIR%\node" 
CALL npm config set --global strict-ssl false

:: gem specfic
IF NOT EXIST "%YAWDS_HOME%\%YAWDS_PKG_INSTALL_DIR%\ruby" (
	MKDIR "%YAWDS_HOME%\%YAWDS_PKG_INSTALL_DIR%\ruby"
)

SET GEM_HOME=%YAWDS_HOME%\%YAWDS_PKG_INSTALL_DIR%\ruby
SET GEM_PATH=%RUBY_HOME%\lib\ruby\gems\1.9.1;%YAWDS_HOME%\%YAWDS_PKG_INSTALL_DIR%\ruby

:: make packages PATH accesible
SET PATH=%YAWDS_HOME%\%YAWDS_PKG_INSTALL_DIR%\node;%YAWDS_HOME%\%YAWDS_PKG_INSTALL_DIR%\ruby\bin;%PATH%

:: setting git config, if exists
IF DEFINED YAWDS_CONF_REQUISITES_GIT (
	IF [%YAWDS_CONF_REQUISITES_GIT%]==[1] (
		IF EXIST "%YAWDS_HOME%\config\user.ini" (
			CALL node "%~dp0node_scripts\set_user_vars" "%YAWDS_HOME%\config\user.ini" "git" > "%~dp0temp\git.bat"
			IF ERRORLEVEL 1 GOTO CONFIG_ERROR
			CALL "%~dp0temp\git.bat"
		)
		:: avoid SSL CA issues
		CALL git config --global http.sslVerify false
		IF DEFINED YAWDS_USER_GIT_USERNAME (
			CALL git config --global user.name "%YAWDS_USER_GIT_USERNAME%"
		)
		IF DEFINED YAWDS_USER_GIT_EMAIL (
			CALL git config --global user.email "%GIT_EMAIL%"
		)
		IF DEFINED YAWDS_USER_GIT_CREDENTIALS (
			IF [%YAWDS_USER_GIT_CREDENTIALS%]==[1] (
				:: enable git credentials store helper (cache mode, with timeout)
				CALL git config --global credentials.helper "cache --timeout=43200"
			)
		)
	)
)

GOTO END

:CONFIG_ERROR
ECHO Cannot read user.ini config due to an error
ECHO Check it and try again
PAUSE
EXIT 1

:END