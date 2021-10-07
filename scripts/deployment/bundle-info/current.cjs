'use strict';

const bundle = require('./bundle.cjs');

(async () => {
  try {
    const current = await bundle.info();

    console.log(`Running on: ${bundle.describe(current)}`);
  } catch (error) {
    console.error(error);
    process.exit(1);
  }
})();
