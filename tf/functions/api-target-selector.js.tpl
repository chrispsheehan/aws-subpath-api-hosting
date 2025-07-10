function handler(event) {
  var request = event.request;
  var headers = request.headers;
  var target = headers["${toggle_header}"]?.value || "";

  if (target === "${beta_header_value}") {
    request.uri = "${beta_path_prefix}" + request.uri;
  } else {
    request.uri = "${alpha_path_prefix}" + request.uri;
  }

  return request;
}
