# aws-subpath-api-hosting

Access an api via the same cloudfront distribution.

*Problem*: Accessing [internal] APIs via domains can result in CORs issues and require mitigation.

*Solution*: Access API via a path from the site making the request.

Thank you to Lewis for his guidance and [repo](https://github.com/Lewiscowles1986/aws-cors-cloudfront)

## access

- obtain url from output as per below

```sh
cloudfront_url = "https://d2t9lieeiaps7k.cloudfront.net"
```

Paths `subpath1/` and `subpath2/` map to index.html files uploaded from `./static` folder.

Each subpath index.html will be able to access the api via `/api` subpath