@echo off
title Fina Berry Startup Script
echo ==========================================
echo        FINA BERRY STARTUP SCRIPT
echo ==========================================

echo Starting Laravel Backend server...
powershell -Command "Start-Process cmd -ArgumentList '/k C:\laragon\bin\php\php-8.3.29-nts-Win32-vs16-x64\php.exe artisan serve --port=8000' -WorkingDirectory 'c:\Users\sobur\Downloads\Web_wfb'"

echo Waiting 3 seconds for server to boot...
timeout /t 3 /nobreak >nul

echo Opening Website...
start http://127.0.0.1:8000

echo Starting Flutter Application...
flutter run -d chrome
