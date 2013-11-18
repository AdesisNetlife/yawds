@ECHO OFF
CLS
IF EXIST "%TEMP%\yawds_update_script.bat" DEL /F /Q "%TEMP%\yawds_update_script.bat"
COPY /Y "%~dp0stack\scripts\update.bat" "%TEMP%\yawds_update_script.bat" > nul
CALL "%~dp0stack\scripts\set_env.bat"
CALL "%~dp0stack\scripts\env_config.bat"
CALL "%TEMP%\yawds_update_script.bat"
DEL /F /Q "%TEMP%\yawds_update_script.bat"
PAUSE
