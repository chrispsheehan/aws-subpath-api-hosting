function handler(event) {
  var request = event.request;
  var headers = request.headers;
  var target = "";

  if (headers["${toggle_header}"] && headers["${toggle_header}"].value) {
    target = headers["${toggle_header}"].value;
  }

  if (request.uri.indexOf("/${api_base_path}") === 0) {
    // Remove the base path (/api) from the URI
    var strippedUri = request.uri.replace(/^\/${api_base_path}/, "");

    // Rebuild the URI with /api/{target}/...
    if (target === "${beta_header_value}") {
      request.uri = "/${api_base_path}/${beta_path_prefix}" + strippedUri;
    } else {
      request.uri = "/${api_base_path}/${alpha_path_prefix}" + strippedUri;
    }
  }

  return request;
}
