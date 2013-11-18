@ECHO OFF
CLS 

:: load environment variables and config
CALL "%~dp0set_env.bat"
:: read and load config from ini files
CALL "%~dp0env_config.bat"

IF DEFINED YAWDS_CONF_GENERAL_CONSOLE_COLOR (
	COLOR %YAWDS_CONF_GENERAL_CONSOLE_COLOR%
)
IF DEFINED YAWDS_CONF_GENERAL_PROMPT (
	SET prompt=%YAWDS_CONF_GENERAL_PROMPT%
)

:: check OS requisites
CALL "%~dp0requisites.bat"
:: environement setup process, if required
CALL "%~dp0setup.bat"
:: load user-specific config
CALL "%~dp0config.bat"
:: performs the environment provisioning if required
CALL "%~dp0provision.bat"

IF [%YAWDS_CONF_UPDATE_CHECK_ON_STARTUP%]==[1] (
	CALL "%~dp0update.bat" --confirm
)

IF NOT EXIST "%YAWDS_HOME%\workspace" (
	MKDIR "%YAWDS_HOME%\workspace"
)

CD "%YAWDS_HOME%\workspace"
