function handler(event) {
  var request = event.request;
  var uri = event.request.uri;

  var hasQuery = Object.keys(request.querystring || {}).length > 0;

  // Append index.html if needed
  if (request.uri.endsWith("/")) {
    request.uri += "index.html";
  } else if (hasQuery) {
    request.uri = "/index.html";
  } else if (!request.uri.includes(".")) {
    request.uri += "/index.html";
  }

  return request;
}
