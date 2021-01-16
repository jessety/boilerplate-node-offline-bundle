'use strict';

const Koa = require('koa');
const Router = require('koa-router');
const parser = require('koa-bodyparser');
const logger = require('koa-logger');

const app = new Koa();
const router = new Router();

app.use(logger());

router.get('/', parser(), context => {
  context.body = 'Hello, world!';
});

app.use(router.routes(), router.allowedMethods());

const port = process.env.PORT || 2021;

app.listen(port, () => {
  console.log(`HTTP server live on port ${port}`);
});
