# Terraform AWS Modules

[![Terraform](https://github.com/hammadhaqqani/terraform/actions/workflows/terraform.yml/badge.svg)](https://github.com/hammadhaqqani/terraform/actions/workflows/terraform.yml)
[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Terraform](https://img.shields.io/badge/Terraform-%235835CC.svg?logo=terraform&logoColor=white)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?logo=amazon-aws&logoColor=white)](https://aws.amazon.com/)
[![Buy Me A Coffee](https://img.shields.io/badge/Buy%20Me%20A%20Coffee-ffdd00?style=flat&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/hammadhaqqani)

Production-ready AWS Terraform modules for provisioning cloud infrastructure. Each module is self-contained with its own `main.tf`, `variable.tf`, `outputs.tf`, and `provider.tf`.

## Modules

| Module | Description | Key Resources |
|--------|-------------|---------------|
| **EC2 / Linux** | Launch EC2 Linux instances with configurable AMI, instance type, and security groups | `aws_instance`, Security Group v5 |
| **EC2 / Windows** | Launch EC2 Windows instances with RDP-ready configuration | `aws_instance`, Security Group v5 |
| **EC2 / Autoscaling** | Auto Scaling Group with launch templates and scaling policies | Autoscaling v8, Launch Template |
| **Network / VPC** | VPC with public/private subnets, NAT gateway, VPN, DHCP, and flow logs | VPC v5 |
| **Network / Security Group** | Security groups with RDS PostgreSQL example | RDS v5, Security Group |
| **RDS / MySQL** | Managed MySQL database with parameter groups and subnet groups | RDS v5 |
| **RDS / PostgreSQL** | Managed PostgreSQL instance with configurable storage and backup | RDS v5 |
| **RDS / Oracle** | Oracle RDS instance for enterprise workloads | RDS v5 |
| **RDS / SQL Server** | SQL Server RDS with license and instance configuration | RDS v5 |
| **NoSQL / DynamoDB** | DynamoDB table with autoscaling, GSIs, and configurable throughput | DynamoDB v4 |
| **S3** | S3 bucket with versioning and server-side encryption | `aws_s3_bucket` |

## Project Structure

```
.
├── Ec2Instance/
│   ├── LinuxEc2Instance/      # Linux EC2 with security group
│   ├── WindowsEc2Instance/    # Windows EC2 with domain join
│   └── autoscaling/           # ASG with launch template
├── Network/
│   ├── VPC/                   # VPC with subnets, NAT, VPN
│   └── Securitygroup/         # Security group + RDS example
├── RDS/
│   ├── mysql/                 # MySQL RDS
│   ├── postgres/              # PostgreSQL RDS
│   ├── oracle/                # Oracle RDS
│   └── sqlrds/                # SQL Server RDS
├── NoSql/
│   └── Dynamodb/              # DynamoDB with autoscaling
└── S3/
    └── S3Bucket/              # S3 with versioning + encryption
```

## Module Versions

All modules use the latest stable community module versions:

| Community Module | Version | Notes |
|-----------------|---------|-------|
| [terraform-aws-modules/security-group/aws](https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws) | ~> 5.0 | EC2 security groups |
| [terraform-aws-modules/autoscaling/aws](https://registry.terraform.io/modules/terraform-aws-modules/autoscaling/aws) | ~> 8.0 | ASG with launch templates |
| [terraform-aws-modules/vpc/aws](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws) | ~> 5.0 | VPC with subnets |
| [terraform-aws-modules/rds/aws](https://registry.terraform.io/modules/terraform-aws-modules/rds/aws) | ~> 5.0 | RDS instances |
| [terraform-aws-modules/dynamodb-table/aws](https://registry.terraform.io/modules/terraform-aws-modules/dynamodb-table/aws) | ~> 4.0 | DynamoDB tables |

## Prerequisites

- [Terraform](https://www.terraform.io/downloads) >= 1.3
- AWS CLI configured with appropriate credentials
- An AWS account with permissions for the resources you want to provision

## Quick Start

```bash
# Clone the repo
git clone https://github.com/hammadhaqqani/terraform.git
cd terraform

# Navigate to a module
cd Ec2Instance/LinuxEc2Instance

# Initialize and apply
terraform init
terraform plan
terraform apply
```

## Usage

Each module directory contains:

- `main.tf` - Resource definitions
- `variable.tf` - Input variables (customize these for your environment)
- `provider.tf` - AWS provider and backend configuration
- `outputs.tf` - Output values (where applicable)

Edit `variable.tf` in any module to set your region, instance types, CIDR blocks, and other parameters before running `terraform apply`.

## CI/CD

Every push runs automated validation via GitHub Actions:

- **`terraform fmt -check -recursive`** - Ensures consistent code formatting across all modules.
- **`terraform init -backend=false`** - Validates module sources and provider requirements.
- **`terraform validate`** - Checks configuration syntax and internal consistency for all 11 modules.

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License

[MIT](LICENSE)

## Author

**Hammad Haqqani** - DevOps Architect & Cloud Engineer

- Website: [hammadhaqqani.com](https://hammadhaqqani.com)
- LinkedIn: [linkedin.com/in/haqqani](https://www.linkedin.com/in/haqqani)
- Email: phaqqani@gmail.com

---

## Support

If you find this useful, consider buying me a coffee!

[![Buy Me A Coffee](https://img.shields.io/badge/Buy%20Me%20A%20Coffee-ffdd00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/hammadhaqqani)
