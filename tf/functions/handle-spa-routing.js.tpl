function handler(event) {
  var request = event.request;
  var uri = request.uri;

  if (uri.startsWith("/${api_base_path}") || uri.includes(".")) {
    return request;
  }

  request.uri = "/index.html";
  return request;
}
