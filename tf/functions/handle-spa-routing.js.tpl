function handler(event) {
  var request = event.request;
  var uri = event.request.uri;

  var queryStrings = [];
  for (var key in event.request.querystring) {
    queryStrings.push(key)
  }

  // Append index.html if needed
  if (request.uri.endsWith("/")) {
    request.uri += "index.html";
  } else if (queryStrings.length > 0) {
    request.uri = "/index.html";
  } else if (!request.uri.includes(".")) {
    request.uri += "/index.html";
  }

  return request;
}
