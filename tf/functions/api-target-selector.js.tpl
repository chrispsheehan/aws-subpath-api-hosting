function handler(event) {
  var request = event.request;
  var headers = request.headers;
  var target = "";

  if (headers["${toggle_header}"] && headers["${toggle_header}"].value) {
    target = headers["${toggle_header}"].value;
  }

  if (request.uri.indexOf("/${api_base_path}") === 0) {
    if (target === "${beta_header_value}") {
      request.uri = "${beta_path_prefix}" + request.uri;
    } else {
      request.uri = "${alpha_path_prefix}" + request.uri;
    }
  }

  return request;
}
