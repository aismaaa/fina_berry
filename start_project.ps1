# Script to run both Laravel Backend and Flutter App in one command!
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "       FINA BERRY STARTUP SCRIPT" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

# 1. Start Laravel Backend in a separate CMD window (so you can view logs)
Write-Host "Starting Laravel Backend server..." -ForegroundColor Yellow
$phpPath = "C:\laragon\bin\php\php-8.3.29-nts-Win32-vs16-x64\php.exe"
$laravelDir = "c:\Users\sobur\Downloads\Web_wfb"

if (Test-Path $phpPath) {
    Start-Process cmd -ArgumentList "/k `"$phpPath`" artisan serve --port=8000" -WorkingDirectory $laravelDir
    Write-Host "✔ Laravel started successfully on http://127.0.0.1:8000" -ForegroundColor Green
} else {
    Write-Host "✖ PHP 8.5 executable not found at: $phpPath" -ForegroundColor Red
    Write-Host "Trying fallback to system php..." -ForegroundColor Yellow
    Start-Process cmd -ArgumentList "/k php artisan serve --port=8000" -WorkingDirectory $laravelDir
    Write-Host "✔ Laravel server triggered." -ForegroundColor Green
}
Start-Sleep -Seconds 3
Start-Process "http://127.0.0.1:8000"

Write-Host "------------------------------------------" -ForegroundColor Gray

# 2. Start Flutter App in the foreground
Write-Host "Starting Flutter Application..." -ForegroundColor Yellow
flutter run -d chrome
