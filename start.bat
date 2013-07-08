@echo off
if "%1" == "" (
  set PORT=8008
) else (
  set PORT=%1
)

cd kalite
if exist database\data.sqlite (
  REM transfer any previously downloaded content from the old location to the new
	move static\videos\* ..\content > nul 2> nul

	reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths" /f "python.exe" /s /k /e /d > nul
	if !ERRORLEVEL! EQU 1 (
		echo -------------------------------------------------------------------
    	echo Error: You do not seem to have Python installed.
    	echo Please install version 2.6 or 2.7, and re-run this script.
    	echo -------------------------------------------------------------------
		cd ..
		exit /b
	)

	echo Starting the cron server in the background.
	start /B runhidden.vbs "cronstart.bat"
	echo Running the web server in the background, on port %PORT%.
	start /B runhidden.vbs "serverstart.bat %PORT%"

	echo The server should now be accessible locally at: http://127.0.0.1:8008/
	echo To access it from another connected computer, try the following:

	for /f "tokens=2 delims=:" %%i in ('ipconfig ^| findstr /R /C:"IPv4 Address" /C:"IP Address"') do (
    	for /f "tokens=1 delims= " %%a in ("%%i") do echo http://%%a:8008/
	)
	
) else (
	echo Please run install.bat first!
)
cd ..