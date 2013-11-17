@ECHO OFF
CLS 

:: load environment variables and config
CALL "%~dp0set_env.bat"
CALL "%~dp0read_config.bat"

IF DEFINED YAWDS_CONF_GENERAL_CONSOLE_COLOR (
	COLOR %YAWDS_CONF_GENERAL_CONSOLE_COLOR%
)
IF DEFINED YAWDS_CONF_GENERAL_PROMPT (
	SET prompt=%YAWDS_CONF_GENERAL_PROMPT%
)

:: environement setup process, if required
CALL "%~dp0setup.bat"
CALL "%~dp0config.bat"

:: CALL "%~dp0scripts\install.bat"
:: CALL "%~dp0scripts\provision.bat"

IF NOT EXIST "%YAWDS_HOME%\workspace" (
	MKDIR "%YAWDS_HOME%\workspace"
)

CD "%YAWDS_HOME%\workspace"
