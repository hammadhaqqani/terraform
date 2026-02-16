# Terraform AWS Modules

[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Terraform](https://img.shields.io/badge/Terraform-%235835CC.svg?logo=terraform&logoColor=white)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?logo=amazon-aws&logoColor=white)](https://aws.amazon.com/)
[![Buy Me A Coffee](https://img.shields.io/badge/Buy%20Me%20A%20Coffee-ffdd00?style=flat&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/hammadhaqqani)

Production-ready AWS Terraform modules for provisioning cloud infrastructure. Each module is self-contained with its own `main.tf`, `variable.tf`, `outputs.tf`, and `provider.tf`.

## Modules

| Module | Description |
|--------|-------------|
| **EC2 / Linux** | Launch EC2 Linux instances with configurable AMI, instance type, and security groups |
| **EC2 / Windows** | Launch EC2 Windows instances with RDP-ready configuration |
| **EC2 / Autoscaling** | Auto Scaling Group with launch configuration and scaling policies |
| **Network / VPC** | VPC with public/private subnets, internet gateway, and route tables |
| **Network / Security Group** | Configurable security groups with ingress/egress rules |
| **RDS / MySQL** | Managed MySQL database with parameter groups and subnet groups |
| **RDS / PostgreSQL** | Managed PostgreSQL instance with configurable storage and backup |
| **RDS / Oracle** | Oracle RDS instance for enterprise workloads |
| **RDS / SQL Server** | SQL Server RDS with license and instance configuration |
| **NoSQL / DynamoDB** | DynamoDB table with configurable hash/range keys and throughput |
| **S3** | S3 bucket with versioning, encryption, and access policies |

## Project Structure

```
.
├── Ec2Instance/
│   ├── LinuxEc2Instance/      # Linux EC2 with graph
│   ├── WindowsEc2Instance/    # Windows EC2 with graph
│   └── autoscaling/           # Auto Scaling Group
├── Network/
│   ├── VPC/                   # VPC with subnets
│   └── Securitygroup/         # Security groups
├── RDS/
│   ├── mysql/                 # MySQL RDS
│   ├── postgres/              # PostgreSQL RDS
│   ├── oracle/                # Oracle RDS
│   └── sqlrds/                # SQL Server RDS
├── NoSql/
│   └── Dynamodb/              # DynamoDB table
└── S3/
    └── S3Bucket/              # S3 bucket
```

## Prerequisites

- [Terraform](https://www.terraform.io/downloads) >= 0.12
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
- `provider.tf` - AWS provider configuration
- `outputs.tf` - Output values (where applicable)

Edit `variable.tf` in any module to set your region, instance types, CIDR blocks, and other parameters before running `terraform apply`.

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
