const express = require('express');
const awsServerlessExpress = require('aws-serverless-express');
const app = express();

// Middleware to log the request URL
app.use((req, res, next) => { 
  const ip = req.headers['x-forwarded-for'] || req.socket.remoteAddress;
  console.log(`Request URL: ${req.originalUrl}`); // Logs the request URL
  next(); // Pass control to the next route or middleware
});

// Define routes this needs to contain the stage path
app.get('/hello', (req, res) => {
  res.status(200).json({msg: "/hello Hello, this is your AWS Lambda function, [mushroom] testy badgers!"});
});


// Define routes this needs to contain the stage path
app.get('/dev/api/hello', (req, res) => {
  res.status(200).json({msg: "/dev/api/hello Hello, this is your AWS Lambda function, [mushroom] testy badgers!"});
});

// Define routes
app.get('/api/hello', (req, res) => {
  res.status(200).json({msg: "/api/hello Hello, this is your AWS Lambda function, [mushroom] testy badgers!"});
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
