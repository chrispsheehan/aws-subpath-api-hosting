# aws-subpath-api-hosting

Access an api via the same cloudfront distribution.

*Problem 1*: Accessing [internal] APIs via domains can result in CORs issues and require mitigation.

*Solution 1*: Access API via a path from the site making the request.

Thank you to Lewis for his guidance and [repo](https://github.com/Lewiscowles1986/aws-cors-cloudfront)

*Problem 2*: When `/api` returns an error by default cloudfront will return its `custom_error_response`. A `custom_error_response` is required by react to catch refreshes direct navigation for non-public s3 buckets.

*Solution 2*: Cloudfront function to add the /index.html for list of paths.
*note*: This can also be done for all paths - if we do not want to hard-code paths. But this means no (valid) 404 errors! all will be redirected to index.html.


*Problem 1*: To a/b test the api served at /api with a static url and not having to update origins (which takes ages..).

*Solution 2*: Cloudfront function to change the path of the request + cloudfront in front of target api with ordered cache behavior to direct to desired api. Updating a cloufront function takes seconds.

## access

- obtain url from output as per below

```sh
cloudfront_url = "https://d2t9lieeiaps7k.cloudfront.net"
```

## infra

![Infrastructure](docs/infra.drawio.png)