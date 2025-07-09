// api-selector.js
function handler(event) {
  var request = event.request;
  var headers = request.headers;
  var target = headers["x-api-target"]?.value || "";

  if (request.uri.startsWith("/api")) {
    if (target === "beta") {
      request.uri = "/api-b" + request.uri;
    } else {
      request.uri = "/api-a" + request.uri;
    }
  }

  return request;
}
