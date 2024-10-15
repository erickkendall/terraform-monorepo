#!/bin/bash

# Create the main directory
mkdir -p terraform-monorepo
cd terraform-monorepo

# Create modules directory and subdirectories
mkdir -p modules/{networking,compute,database}

# Create files in each module directory
for module in networking compute database; do
    touch modules/$module/{main.tf,variables.tf,outputs.tf}
done

# Create environments directory and subdirectories
mkdir -p environments/{dev,staging,prod}

# Create files in each environment directory
for env in dev staging prod; do
    touch environments/$env/{main.tf,variables.tf,terraform.tfvars}
done

# Create CI directory and pipeline file
mkdir -p ci
touch ci/pipeline.yml

# Create README file
touch README.md

echo "Terraform monorepo structure created successfully!"

# Print the directory structure
echo "Directory structure:"
tree -L 3
