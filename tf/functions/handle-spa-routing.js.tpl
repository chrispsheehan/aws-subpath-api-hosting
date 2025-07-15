function handler(event) {
  var request = event.request;
  var uri = request.uri;

  if (uri.startsWith("/api") || uri.includes(".")) {
    return request;
  }

  var knownRoutes = ["/", "/page1"];
  for (var i = 0; i < knownRoutes.length; i++) {
    if (uri === knownRoutes[i]) {
      request.uri = "/index.html";
      break;
    }
  }

  return request;
}
