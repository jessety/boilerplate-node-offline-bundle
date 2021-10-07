#!/bin/bash

echo "=== Unbundle ==="

archive="./bundle.tar.gz"

# Print out the versions of this package, node, and npm for this host
node scripts/deployment/bundle-info/current.cjs

# Check connectivity to the npm and gpr registry
node scripts/deployment/test-connection/both.cjs

if [ $? -eq 0 ]; then

  echo "Installing dependencies.."

  npm install --production --force --loglevel=error --no-audit --no-fund --ignore-scripts

else

  echo "Cannot connect to the npm registry. Checking for offline bundle.."

  if [ -f $archive ]; then

    echo "Dependency bundle detected. Decompressing.."

    # Extract the archive to create the node_modules folder
    tar -xzf $archive

    # Read the bundle information file and compare it to the current host
    node scripts/deployment/bundle-info/compare.cjs

  else

    echo "Dependency bundle not detected. Attempting install anyway.."

    npm install --production --loglevel=error --no-audit --no-fund --ignore-scripts
  fi
fi

echo "=== Unbundle Complete ==="
