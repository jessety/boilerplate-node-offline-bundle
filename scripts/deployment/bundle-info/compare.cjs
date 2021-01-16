'use strict';

const bundle = require('./bundle.cjs');

(async () => {

  try {

    const current = await bundle.info();

    const bundled = await bundle.read();

    const valid = await bundle.compare(bundled, current);

    if (valid === false) {
      process.exit(1);
    }

  } catch (error) {

    console.error(error);
    process.exit(1);
  }
})();
