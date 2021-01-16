'use strict';

const bundle = require('./bundle.cjs');

(async () => {

  try {

    const info = await bundle.write();

    console.log(`Bundled ${bundle.describe(info)}`);

  } catch (error) {

    console.error(error);
    process.exit(1);
  }
})();
