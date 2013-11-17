@ECHO OFF
:: do not call this script manually

:: use this script to load specific environment variables
:: useful for custom scripts and continous integration jobs

CALL "%~dp0set_env.bat"
CALL "%~dp0env_config.bat"
CALL "%~dp0config.bat"
