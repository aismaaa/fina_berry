@echo off
title Fina Berry Startup Script
echo ==========================================
echo        FINA BERRY STARTUP SCRIPT
echo ==========================================

echo Starting Laravel Backend server...
powershell -Command "Start-Process cmd -ArgumentList '/k C:\laragon\bin\php\php-8.3.29-nts-Win32-vs16-x64\php.exe artisan serve --host=0.0.0.0 --port=8000' -WorkingDirectory 'c:\Users\sobur\Downloads\Web_wfb'"

echo Waiting 3 seconds for server to boot...
timeout /t 3 /nobreak >nul

echo Opening Website...
start http://192.168.101.22:8000

echo Starting Flutter Application for Network Access...
echo You can access the app on your phone at http://192.168.101.22:8080
flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080
