zip-path:
    #!/usr/bin/env bash
    echo {{justfile_directory()}}/api.zip

index-path:
    #!/usr/bin/env bash
    echo {{justfile_directory()}}/static/index.html

format:
    #!/usr/bin/env bash
    cd tf
    terraform fmt --recursive

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
    terraform plan -var lambda_zip_path=$(just zip-path)

deploy:
    #!/usr/bin/env bash
    set -euo pipefail
    just build
    cd tf
    terraform init
    terraform apply -var lambda_zip_path=$(just zip-path)

local-deploy:
    #!/usr/bin/env bash
    just deploy
    cd tf  
    STATIC_BUCKET_NAME=$(terraform output -raw static_bucket_name)
    aws s3 sync {{justfile_directory()}}/static s3://$STATIC_BUCKET_NAME/ --delete

destroy:
    #!/usr/bin/env bash
    set -euo pipefail
    cd tf
    terraform init
    terraform destroy -var lambda_zip_path=$(just zip-path)
