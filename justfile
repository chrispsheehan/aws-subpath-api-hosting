zip-path:
    #!/usr/bin/env bash
    echo {{justfile_directory()}}/api.zip

build:
    #!/usr/bin/env bash
    zip_path=$(just zip-path)
    cd src
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
    just build
    cd tf
    terraform init
    terraform apply -var lambda_zip_path=$(just zip-path)

destroy:
    #!/usr/bin/env bash
    cd tf
    terraform init
    terraform destroy -var lambda_zip_path=$(just zip-path)