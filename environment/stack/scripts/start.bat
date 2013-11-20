@ECHO OFF
CLS 

:: load environment variables and config
CALL "%~dp0set_env.bat"
:: read and load config from ini files
CALL "%~dp0env_config.bat"
:: check OS pre-requisites
CALL "%~dp0requisites.bat"
:: environement setup process, if required
CALL "%~dp0setup.bat"
:: load user-specific config
CALL "%~dp0config.bat"
:: performs the environment packages provisioning if enabled
CALL "%~dp0provision.bat"
:: define final post-processes env variables
CALL "%~dp0post_set_env.bat"

IF DEFINED YAWDS_CONF_GENERAL_CONSOLE_COLOR (
	COLOR %YAWDS_CONF_GENERAL_CONSOLE_COLOR%
)

IF DEFINED YAWDS_CONF_GENERAL_PROMPT (
	SET prompt=%YAWDS_CONF_GENERAL_PROMPT%
)

IF [%YAWDS_CONF_UPDATE_CHECK_ON_STARTUP%]==[1] (
	CALL "%~dp0update.bat" --confirm
)

IF NOT EXIST "%YAWDS_HOME%\workspace" (
	MKDIR "%YAWDS_HOME%\workspace"
)

IF DEFINED YAWDS_CONF_SCRIPTS_AFTER_START (
	IF EXIST "%YAWDS_STACK_PATH%\%YAWDS_CONF_SCRIPTS_AFTER_START%" (
		CALL "%YAWDS_STACK_PATH%\%YAWDS_CONF_SCRIPTS_AFTER_START%"
	)
)

CD "%YAWDS_HOME%\workspace"
