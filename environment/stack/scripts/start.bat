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

:: environement setup process, if required
CALL "%~dp0setup.bat"
:: check OS requisites
CALL "%~dp0requisites.bat"
:: set user-specific config
CALL "%~dp0config.bat"
:: performs the environment provisioning if required
CALL "%~dp0provision.bat"

IF NOT EXIST "%YAWDS_HOME%\workspace" (
	MKDIR "%YAWDS_HOME%\workspace"
)

CD "%YAWDS_HOME%\workspace"
