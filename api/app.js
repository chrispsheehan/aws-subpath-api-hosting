const express = require('express');
const awsServerlessExpress = require('aws-serverless-express');
const app = express();

const basePath = "/dev/api/"

// remove base path from the call url
app.use((req, res, next) => {
  if (req.url.startsWith(basePath)) {
      req.url = req.url.slice(basePath.length);
  }
  next();
});

// Define routes this needs to contain the stage path
app.get('/hello', (req, res) => {
  const apiName = process.env.API_NAME || 'unknown-api';
  res.status(200).json({
    msg: `/hello from ${apiName}, AWS Lambda is alive!`
  });
});

// Catch-all route for unmatched paths
app.use((req, res) => {
  const ip = req.headers['x-forwarded-for'] || req.socket.remoteAddress;
  res.status(200).json({msg: `Hello, here's your IP: ${ip} req ${req.url}`});
});

// Create and export the server
const server = awsServerlessExpress.createServer(app);

exports.handler = (event, context) => {
  awsServerlessExpress.proxy(server, event, context);
};
