zip-path:
    #!/usr/bin/env bash
    echo {{justfile_directory()}}/api.zip

index-path:
    #!/usr/bin/env bash
    echo {{justfile_directory()}}/index.html

build:
    #!/usr/bin/env bash
    zip_path=$(just zip-path)
    cd api
    npm install
    rm -f $zip_path
    zip -r $zip_path *

plan:
    #!/usr/bin/env bash
    cd tf
    terraform init
    terraform plan -var lambda_zip_path=$(just zip-path) -var index_file_path=$(just index-path)

deploy:
    #!/usr/bin/env bash
    set -euo pipefail
    just build
    cd tf
    terraform init
    terraform apply --auto-approve -var lambda_zip_path=$(just zip-path) -var index_file_path=$(just index-path)

destroy:
    #!/usr/bin/env bash
    set -euo pipefail
    cd tf
    terraform init
    terraform destroy --auto-approve -var lambda_zip_path=$(just zip-path) -var index_file_path=$(just index-path)