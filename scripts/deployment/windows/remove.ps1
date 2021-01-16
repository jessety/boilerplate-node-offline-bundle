Write-Host "=== Remove ==="

Write-Host "Removing from pm2.."
pm2 delete ecosystem.config.json --silent

Write-Host "Saving pm2 configuration.."
pm2 save --force --silent

Write-Host "=== Remove Complete ==="
