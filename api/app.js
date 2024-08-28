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
  res.status(200).json({msg: "/hello Hello, this is your AWS Lambda function, [mushroom] testy badgers!"});
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
