$ErrorActionPreference = 'SilentlyContinue'

Write-Host "=== Setup ==="

Write-Host "Installing.."
& .\scripts\deployment\windows\unbundle.ps1

Write-Host "Updating PM2 environmental variables.."
# Reload the following environmental variables: path, pm2_home, pm2_service_pm2_dir
$Env:path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
$Env:PM2_HOME = [System.Environment]::GetEnvironmentVariable("PM2_HOME", "Machine");
$Env:PM2_SERVICE_PM2_DIR = [System.Environment]::GetEnvironmentVariable("PM2_SERVICE_PM2_DIR", "Machine");

Write-Host "Adding to pm2.."
pm2 start ecosystem.config.json --silent

Write-Host "Saving pm2 configuration.."
pm2 save --force --silent

Write-Host "=== Setup Complete ==="
