Write-Host "=== Bundle ==="

$folder = ".\node_modules";
$archive_tar=".\bundle.tar.gz"
$archive_zip = ".\bundle.zip";

if (Test-Path $folder) {
  Write-Host "Existing dependencies folder detected, removing.."
  Remove-Item $folder -recurse -force | Out-Null
}

if (Test-Path $archive_tar) {
  Write-Host "Existing dependencies archive tar detected, removing.."
  Remove-Item $archive_tar | Out-Null
}

if (Test-Path $archive_zip) {
  Write-Host "Existing dependencies archive zip detected, removing.."
  Remove-Item $archive_zip | Out-Null
}

Write-Host "Populating dependencies.."
npm install --production --force --loglevel=error --no-audit --no-fund

if (Get-Command "tar.exe" -ErrorAction SilentlyContinue) {

  Write-Host "Compressing dependencies using tar.."
  $BeforeTar = Get-Date
  tar -czf $archive_tar $folder
  Write-Host "Compressing dependencies into $archive_tar took $([Math]::Floor($(Get-Date).Subtract($BeforeTar).TotalSeconds)) seconds."

} else {

  Write-Host "WARNING: tar.exe is not available, not compressing dependencies into a .tar.gz."
  Write-Host "         Offline installs will use .zip instead, and may be considerably slower."
  Write-Host "         To install tar.exe, update to the latest version of Windows 10."
}

Write-Host "Compressing dependencies using zip.."
$BeforeZip = Get-Date
Compress-Archive -CompressionLevel Fastest -Path $folder -DestinationPath $archive_zip
Write-Host "Compressing dependencies into $archive_zip took $([Math]::Floor($(Get-Date).Subtract($BeforeZip).TotalSeconds)) seconds."

Write-Host "Removing uncompressed dependencies.."
Remove-Item $folder -recurse -force | Out-Null

Write-Host "Writing bundle info file.."
node .\scripts\deployment\bundle-info\write.cjs

Write-Host "=== Bundle Complete ==="
