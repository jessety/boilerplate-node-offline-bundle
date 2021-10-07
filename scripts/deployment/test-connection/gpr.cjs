#!/usr/bin/env node

'use strict';

const https = require('https');

const host = 'npm.pkg.github.com';
const path = '/download';
const timeout = 2500;

console.log('Checking connectivity to the gpr registry..');

const request = https.request({ host, path, timeout }, (response) => {
  if (response.statusCode !== 404) {
    console.error(`Received unexpected status code from ${host}: ${response.statusCode}`);
    process.exit(1);
  }

  if (response.headers['x-github-request-id'] === undefined) {
    console.error(`Received unexpected headers from ${host}:`, response.headers);
    process.exit(1);
  }

  console.log(`Successfully connected to ${host}.`);
});

request.on('timeout', () => request.abort());

request.on('error', (error) => {
  console.error(`Could not connect to ${host}: ${error.message}`);
  process.exit(1);
});

request.end();
