zip-path:
    #!/usr/bin/env bash
    echo {{justfile_directory()}}/api.zip

format:
    #!/usr/bin/env bash
    cd tf
    terraform fmt --recursive

api-build:
    #!/usr/bin/env bash
    zip_path=$(just zip-path)
    cd api
    npm install
    rm -f $zip_path
    zip -r $zip_path *

frontend-build:
    #!/usr/bin/env bash
    cd frontend
    npm i
    npm run build

build:
  just api-build
  just frontend-build

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
    UI_DIST_ID=$(terraform output -raw ui_dist_id)
    API_DIST_ID=$(terraform output -raw api_dist_id)
    aws s3 sync {{justfile_directory()}}/dist s3://$STATIC_BUCKET_NAME/ --delete
    aws cloudfront create-invalidation --distribution-id $UI_DIST_ID --paths "/*" --output text
    aws cloudfront create-invalidation --distribution-id $API_DIST_ID --paths "/*" --output text

destroy:
    #!/usr/bin/env bash
    set -euo pipefail
    cd tf
    terraform init
    terraform destroy -var lambda_zip_path=$(just zip-path)
