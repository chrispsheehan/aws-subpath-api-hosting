function handler(event) {
  var request = event.request;
  var uri = request.uri;

  // Bypass API and static assets
  if (uri.startsWith("/${api_base_path}") || uri.includes(".")) {
    return request;
  }

  var knownRoutes = ${jsonencode(known_routes)};

  // If knownRoutes is empty, rewrite all non-API routes
  if (knownRoutes.length === 0) {
    request.uri = "/index.html";
    return request;
  }

  // Otherwise, only rewrite known paths
  for (var i = 0; i < knownRoutes.length; i++) {
    if (uri === knownRoutes[i]) {
      request.uri = "/index.html";
      break;
    }
  }

  return request;
}
