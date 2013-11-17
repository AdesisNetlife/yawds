@ECHO OFF
:: use this script to load environment variables for own purposes
:: useful for continous integration stuff

CALL "%~dp0set_env.bat"
CALL "%~dp0read_config.bat"
