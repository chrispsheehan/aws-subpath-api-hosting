function handler(event) {
  var request = event.request;
  var uri = request.uri;

  var isProxyMode = ${is_proxy_mode};
  var proxyPrefix = "${proxy_path_prefix}";
  var basePath = "${api_base_path}";

  if (isProxyMode && uri.startsWith("/" + basePath + "/")) {
    var strippedUri = uri.substring(("/" + basePath).length);
    request.uri = "/" + basePath + "/" + proxyPrefix + strippedUri;
  }

  return request;
}
