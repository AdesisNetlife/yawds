@ECHO OFF

IF DEFINED YAWDS_HOME GOTO END

:: setting specific environment variables
SET YAWDS_HOME=%~dp0..\..
SET YAWDS_STACK_PATH=%~dp0..

:: binary tools
SET YAWDS_TOOLS_PATH=%~dp0..\tools

:: node
SET NODE_HOME=%YAWDS_STACK_PATH%\node

:: embedded browsers
SET YAWDS_HOME_PHANTOMJS=%YAWDS_STACK_PATH%\phantomjs
SET PHANTOMJS_BIN=%YAWDS_HOME_PHANTOMJS%\phantomjs.exe
SET YAWDS_HOME_SLIMERJS=%YAWDS_STACK_PATH%\slimerjs
SET SLIMERJS_BIN=%YAWDS_STACK_PATH%\slimerjs\slimerjs.bat
SET SLIMERJSLAUNCHER=%YAWDS_STACK_PATH%\slimerjs\xulrunner\xulrunner.exe
SET YAWDS_HOME_CASPERJS=%YAWDS_STACK_PATH%\casperjs\batchbin

:: ruby
SET RUBY_HOME=%YAWDS_STACK_PATH%\ruby

:: update PATH
SET PATH=%NODE_HOME%;%YAWDS_HOME_PHANTOMJS%;%RUBY_HOME%\bin;%YAWDS_HOME_CASPERJS%;%YAWDS_HOME_SLIMERJS%;%YAWDS_TOOLS_PATH%;%YAWDS_TOOLS_PATH%\win-bash;%PATH%

:: auto discover binaries directories for aditional packages
:: useful to automatically add them to be path accesible
IF EXIST "%YAWDS_HOME%\packages" (
	SET CWD=%CD%
	CD "%YAWDS_HOME%\packages"
	FOR /D %%i IN (*.*) DO (
		IF NOT [%%i]==[ruby] (
			IF EXIST "%YAWDS_HOME%\packages\%%i\bin" (
				SET PATH=%%YAWDS_HOME%\packages\%%i\bin%;%PATH%
			)
		)
	)
	CD "%CWD%"
)

:END
