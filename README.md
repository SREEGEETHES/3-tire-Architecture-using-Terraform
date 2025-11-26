# 🌐 AWS Three-Tier Architecture using Terraform

This project automates the provisioning of a **three-tier web application architecture on AWS** using **Terraform (IaC)**.  
The deployment includes **VPC + ALB + Auto Scaling Group + RDS** following AWS best practices and complete modularization.

---

## 🏗️ Architecture Overview

| Layer | AWS Services | Description |
|------|-------------|-------------|
| Web / Presentation Layer | **Application Load Balancer (ALB)** | Distributes traffic across EC2 instances in multiple AZs |
| App Layer | **EC2 Auto Scaling Group (PHP + Apache)** | Hosts the PHP application with automatic scaling |
| Database Layer | **Amazon RDS MySQL** | Central DB backend, optionally configured for Multi-AZ |

All resources are deployed inside a **custom VPC** spanning 3 Availability Zones.

```
VPC (CIDR /16)
├── Public Subnets  (ALB + NAT)
├── App Subnets     (Auto Scaling EC2)
└── DB Subnets      (RDS MySQL)
```

---

## 📁 Project Structure

```
.
├── backend.tf               # Remote backend configuration (S3 + DynamoDB locking)
├── versions.tf              # Provider & module version constraints
├── variables.tf             # Variable declarations
├── terraform.tfvars         # Variable definitions
├── vpc.tf                   # VPC module
├── alb.tf                   # Application Load Balancer module
├── asg.tf                   # Auto Scaling + Launch Template + User Data
├── rds.tf                   # RDS MySQL module
└── outputs.tf               # Export useful resource attributes
```

---

## 🔧 Key Features

✔️ Fully automated **3-tier infrastructure**  
✔️ Deploys to **multi-AZ** across us-east-1  
✔️ Uses **official Terraform AWS modules** (no reinventing the wheel)  
✔️ **Remote backend with state locking** (S3 + DynamoDB)  
✔️ **User-data** to install and configure PHP + Apache + phpMyAdmin  
✔️ **Stickiness support** for phpMyAdmin login (ALB cookie)  
✔️ Production-friendly **security groups per tier**  
✔️ Clean, modular, reusable code following Terraform best practices

---

## 🛑 Prerequisites

To run this project, ensure you have:

| Requirement | Version |
|------------|---------|
| AWS Account | Required |
| AWS CLI | Configured with `aws configure` |
| Terraform | v1.x |
| S3 Bucket | For storing state |
| DynamoDB Table | For state locking |

⚠️ Remote backend must be created **before `terraform init`**.

---

## ▶️ How to Deploy

```sh
terraform init
terraform plan
terraform apply
```

Confirm with `yes` when prompted.

⏳ RDS creation may take **10–15 minutes**.

---

## 🔑 Accessing the Application

After deployment completes:

1. Go to **EC2 → Load Balancers**
2. Copy the **ALB DNS Name**
3. Open in browser:

```
http://<ALB-DNS>
```

To access phpMyAdmin:

```
http://<ALB-DNS>/phpmyadmin
```

Retrieve generated RDS password:

```sh
terraform output db_instance_password
```

---

## 🔐 Networking & Security Rules

| Source ➜ Destination | Port | Purpose |
|----------------------|------|---------|
| Internet ➜ ALB | 80 | Public access |
| ALB ➜ ASG Instances | 80 | Web traffic |
| ASG Instances ➜ RDS | 3306 | MySQL access |

---

## 🔍 Health Check Fix (Important)

Initially, health checks may fail because there is no `/` path.  
The fix is to set:

```
Health check path: /phpinfo.php
```

This is handled in module configuration.

---

## 📌 Outputs

After provisioning, important values are displayed:

| Output Key | Description |
|------------|-------------|
| vpc_id | VPC where infra is deployed |
| public_subnets | List of public subnets |
| alb_dns_name | URL to access the app |
| db_endpoint | RDS hostname |
| db_instance_password | Auto-generated DB password |

---

## 🧹 Cleanup (to avoid AWS costs)

```sh
terraform destroy
```

---

## 📚 Recommended Learning Path (for full clarity)

To understand this project end-to-end:

1. VPC, Subnets, IGW, NAT
2. Security Groups & Routing
3. ALB + Target Groups
4. EC2 Auto Scaling
5. RDS MySQL
6. Terraform modules, variables, remote backend & locking

---

## 🙌 Credits

Inspired by the **Three-Tier Architecture on AWS using Terraform** video tutorial.  
Purpose: Hands-on learning & real-world IaC deployment workflow.

---

## ⭐ Contribute

PRs are welcome for:
- Multi-AZ RDS failover mode
- HTTPS/ACM SSL for ALB
- Private containerized app deployment (ECS)

---

## 📄 License

This project is for **educational & demonstration purposes only**.  
Use cautiously before applying to production workloads.

