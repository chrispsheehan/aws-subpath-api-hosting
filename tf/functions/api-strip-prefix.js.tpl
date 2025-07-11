function handler(event) {
  var request = event.request;
  if (request.uri.startsWith("/${prefix_to_strip}/")) {
    request.uri = request.uri.replace("/${prefix_to_strip}", "");
    if (request.uri === "") request.uri = "/";
  }
  return request;
}
