#!/bin/bash

echo "=== Bundle ==="

folder="./node_modules"
archive="./bundle.tar.gz"

if [ -d $folder ]; then
  echo "Existing dependencies folder detected, removing.."
  rm -rf $folder
fi

if [ -f $archive ]; then
  echo "Existing dependencies archive detected, removing.."
  rm -f $archive
fi

echo "Populating dependencies.."
npm install --production --force --loglevel=error --no-audit --no-fund --ignore-scripts

echo "Compressing dependencies.."
tar -czf $archive $folder

echo "Removing uncompressed dependencies.."
rm -rf $folder

echo "Writing bundle info file.."
node ./scripts/deployment/bundle-info/write.cjs

echo "=== Bundle Complete ==="
