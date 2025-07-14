const express = require('express');
const awsServerlessExpress = require('aws-serverless-express');
const app = express();

const basePath = process.env.STAGE_NAME || 'unknown-stage';
const apiName = process.env.API_NAME || 'unknown-api';

// remove base path from the call url
app.use((req, res, next) => {
  if (req.url.startsWith(basePath)) {
      req.url = req.url.slice(basePath.length);
  }
  next();
});


// Route for /hello
app.get('/hello', (req, res) => {
  const ip = req.headers['x-forwarded-for'] || req.socket.remoteAddress;
  res.status(200).json({
    msg: `/hello AWS Lambda is alive!`,
    ip: ip,
    path: req.url,
    apiName: apiName
  });
});

app.get('/no-auth', (req, res) => {
  res.status(401).json({
    message: "Unauthorized"
  });
});

app.get('/forbidden', (req, res) => {
  res.status(403).json({
    message: "Forbidden"
  });
});

app.get('/error', (req, res) => {
  res.status(500).json({
    message: "Internal server error"
  });
});

// Catch-all route
app.use((req, res) => {
  const ip = req.headers['x-forwarded-for'] || req.socket.remoteAddress;
  res.status(200).json({
    msg: `Hello from catch-all`,
    ip: ip,
    path: req.url,
    apiName: apiName
  });
});

// Create and export the server
const server = awsServerlessExpress.createServer(app);

exports.handler = (event, context) => {
  awsServerlessExpress.proxy(server, event, context);
};
