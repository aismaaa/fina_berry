#!/usr/bin/env pwsh
# ============================================================
# Script Build & Push Docker Image ke Docker Hub
# Jalankan di Windows PowerShell dari folder Backend/
# ============================================================

param(
    [string]$DockerHubUser = "shabeuy",
    [string]$ImageName = "finaberry-app",
    [string]$Tag = "latest"
)

$FullImage = "$DockerHubUser/${ImageName}:${Tag}"
$FullImageLatest = "$DockerHubUser/${ImageName}:latest"

Write-Host "=== Fina Berry - Build & Push Docker Image ===" -ForegroundColor Cyan
Write-Host "Image: $FullImage" -ForegroundColor Yellow

# 1. Login ke Docker Hub
Write-Host "`n[1/4] Login ke Docker Hub..." -ForegroundColor Green
docker login
if ($LASTEXITCODE -ne 0) { Write-Host "Login gagal!" -ForegroundColor Red; exit 1 }

# 2. Build image
Write-Host "`n[2/4] Building Docker image..." -ForegroundColor Green
docker build -t $FullImage -t $FullImageLatest .
if ($LASTEXITCODE -ne 0) { Write-Host "Build gagal!" -ForegroundColor Red; exit 1 }

# 3. Push image
Write-Host "`n[3/4] Pushing image ke Docker Hub..." -ForegroundColor Green
docker push $FullImage
docker push $FullImageLatest
if ($LASTEXITCODE -ne 0) { Write-Host "Push gagal!" -ForegroundColor Red; exit 1 }

Write-Host "`n[4/4] Selesai!" -ForegroundColor Green
Write-Host "Image berhasil di-push ke: $FullImage" -ForegroundColor Cyan
Write-Host ""
Write-Host "=== Langkah selanjutnya di VPS ===" -ForegroundColor Yellow
Write-Host "1. Upload file docker-compose.prod.yml dan .env ke VPS"
Write-Host "2. Jalankan: docker pull $FullImage"
Write-Host "3. Jalankan: docker-compose -f docker-compose.prod.yml up -d"
