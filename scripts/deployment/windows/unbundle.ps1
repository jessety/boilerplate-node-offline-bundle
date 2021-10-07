$ErrorActionPreference = 'SilentlyContinue'

Write-Host "=== Unbundle ==="

$archive_tar=".\bundle.tar.gz"
$archive_zip = ".\bundle.zip";

# Print out the versions of this package, node, and npm for this host
node scripts\deployment\bundle-info\current.cjs

# Check connectivity to the npm and gpr registry
node scripts\deployment\test-connection\both.cjs

if ($? -eq $True) {

  Write-Host "Installing dependencies.."

  npm install --production --force --loglevel=error --no-audit --no-fund --ignore-scripts

} else {

  Write-Host "Cannot connect to the npm registry. Checking for offline bundle.."

  # Check if a tar.gz bundle is included. If so, and tar.exe is installed, decompress the tar file.
  # Otherwise, decompress the .zip file.
  # tar.exe is much, much faster- but was only included in standard Windows installations relatively recently
  # On a VM, I've seen tar.exe and Expand-Archive take 12 vs 139 seconds respectively

  if ((Get-Command "tar.exe" -ErrorAction SilentlyContinue) -and (Test-Path $archive_tar)) {

    Write-Host "Dependency tar bundle detected, and tar.exe is available. Decompressing.."

    # Extract the archive to create the node_modules folder
    $BeforeTar = Get-Date
    tar.exe -xzf $archive_tar
    Write-Host "Decompressing $archive_tar took $([Math]::Floor($(Get-Date).Subtract($BeforeTar).TotalSeconds)) seconds."

    # Read the bundle information file and compare it to the current host
    node scripts\deployment\bundle-info\compare.cjs

  } elseif ((Get-Command "Expand-Archive" -ErrorAction SilentlyContinue) -and (Test-Path $archive_zip)) {

    # Print whether tar.exe is installed

    if (Get-Command "tar.exe" -ErrorAction SilentlyContinue) {
      Write-Host "tar.exe is available, but $archive_tar was not detected."
    } else {
      Write-Host "tar.exe is not available."
    }

    Write-Host "Dependency zip bundle detected, and Expand-Archive is available. Decompressing.."

    # Extract the archive to create the node_modules folder
    $BeforeZip = Get-Date
    Expand-Archive -Force -Path $archive_zip -DestinationPath .\
    Write-Host "Decompressing $archive_zip took $([Math]::Floor($(Get-Date).Subtract($BeforeZip).TotalSeconds)) seconds."

    # Read the bundle information file and compare it to the current host
    node scripts\deployment\bundle-info\compare.cjs

  } elseif ((Test-Path $archive_tar) -or (Test-Path $archive_zip)) {

    if (Test-Path $archive_tar) {
      Write-Host "$archive_tar was detected, but tar.exe is unavailable. It was introduced in Windows 10 version 1803 in April 2018."
    }

    if (Test-Path $archive_zip) {
      Write-Host "$archive_zip was detected, but the PowerShell Expand-Archive cmdlet is unavailable. It was introduced in PowerShell 5.0 in February 2016."
    }

    Write-Error "Could not extract offline bundle. Manually extract $archive_tar or $archive_zip manually and run this script again." -ErrorAction Stop

  } else {

    Write-Host "Cannot connect to the npm registry, and no offline bundle was found. Attempting install anyway.."

    # This will probably not work.

    npm install --production --loglevel=error --no-audit --no-fund --ignore-scripts
  }
}

Write-Host "=== Unbundle Complete ==="
