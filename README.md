# VPC Stack Portfolio Project

This repository shows the same AWS infrastructure built two ways:

- `cloudformation/` for AWS-native stack deployment
- `terraform/` for Terraform plan/apply workflow

## Project structure

```text
vpc-stack/
├── cloudformation/
│   └── vpc-stack.yaml
├── terraform/
│   ├── providers.tf
│   ├── variables.tf
│   ├── network.tf
│   ├── security.tf
│   ├── iam.tf
│   ├── compute.tf
│   ├── outputs.tf
│   └── main.tf
├── ARCHITECTURE.md
└── README.md
```

## What this builds

- VPC (`10.0.0.0/16`)
- Public subnet (`10.0.2.0/24`) and private subnet (`10.0.1.0/24`)
- Internet Gateway + NAT Gateway
- Public and private route tables + associations
- IAM role and instance profile with SSM managed policy
- Public EC2 instance (installs nginx via user data)
- Private EC2 instance (ingress only from public instance security group)

## Security notes

- Public security group allows HTTP (`80/tcp`) from `0.0.0.0/0` for demo visibility.
- No SSH (`22`) ingress is configured.
- Private instance security group only allows HTTP + ICMP from the public security group.

## Deploy with CloudFormation

```bash
aws cloudformation deploy \
  --template-file cloudformation/vpc-stack.yaml \
  --stack-name vpc-stack-cfn \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameter-overrides \
    VpcName=my-vpc \
    AvailabilityZone=us-east-1a \
    InstanceType=t3.micro
```

## Deploy with Terraform

From the `terraform/` folder:

```bash
terraform init -upgrade
terraform validate

terraform plan -out tfplan \
  -var="availability_zone=us-east-1a" \
  -var="vpc_name=my-vpc-portfolio" \
  -var="project_name=my-vpc" \
  -var="environment=dev" \
  -var="owner=orie"

terraform apply tfplan
terraform output
```

## Cleanup

CloudFormation:

```bash
aws cloudformation delete-stack --stack-name vpc-stack-cfn
```

Terraform:

```bash
cd terraform
terraform destroy
```

## What shows on GitHub

- Only source files you commit are visible (YAML, `.tf`, markdown, and any other tracked files).
- Terraform state and plan artifacts are excluded with `.gitignore`.
- AWS resources themselves do not appear in GitHub unless you add screenshots.

## Suggested upload flow

```bash
cd /mnt/d/Projects/portfolio/vpc-stack
git init
git add .
git commit -m "Add VPC stack portfolio project (CloudFormation + Terraform)"
git branch -M main
git remote add origin <your-repo-url>
git push -u origin main
```

## How to explain this project

- I implemented one architecture in both CloudFormation and Terraform to compare IaC workflows.
- CloudFormation gives a native AWS stack experience.
- Terraform gives a plan/apply/state model and provider tagging for management traceability.
- Both versions deploy equivalent resources and networking behavior.

See `ARCHITECTURE.md` for a diagram and traffic flow details.
