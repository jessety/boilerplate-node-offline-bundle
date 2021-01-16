#!/bin/bash

echo "=== Setup ==="

echo "Installing.."
bash ./scripts/deployment/unix/unbundle.sh

if [ $? -ne 0 ]; then
  exit $?
fi

echo "Adding to pm2.."
pm2 start ecosystem.config.json --silent

echo "Saving pm2 configuration.."
pm2 save --force --silent

echo "=== Setup Complete ==="
