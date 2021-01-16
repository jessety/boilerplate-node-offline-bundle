#!/bin/bash

echo "=== Remove ==="

echo "Removing from pm2.."
pm2 delete ecosystem.config.json --silent

echo "Saving pm2 configuration.."
pm2 save --force --silent

echo "=== Remove Complete ==="
