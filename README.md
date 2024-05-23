
# Multi-Tier Architecture on AWS using Terraform

Deploy a scalable and resilient multi-tier architecture on AWS using Terraform.

## 🚀 Project Overview

This project allows us to deploy a highly available, scalable, and secure multi-tier architecture on Amazon Web Services (AWS) using Terraform. The architecture consists of the following three tiers:

- **Web Tier**: This tier handles incoming user requests and can be horizontally scaled for increased capacity. It typically includes web servers and a load balancer for distributing traffic.

- **Application Tier**: Application servers run our business logic and interact with the database tier. They can also be horizontally scaled to meet demand.

- **Database Tier**: The database stores and manages our application data. In this architecture, we use Amazon RDS for a managed database service.


## 🚦 Getting Started

### Prerequisites

Before you get started, make sure you have the following prerequisites in place:

- [Terraform](https://www.terraform.io/) installed.
- AWS IAM credentials configured.
- Git for cloning the repository.


## ✨ Features

- **High Availability**: The architecture is designed for fault tolerance and redundancy.
- **Scalability**: Easily scale the web and application tiers to handle varying workloads.
- **Security**: Security groups and network ACLs are configured to ensure a secure environment.

## 🌟 Web Tier

The Web Tier is the entry point for incoming user requests. It typically includes:

- **Load Balancer**: Distributes traffic across multiple web servers.
- **Auto Scaling**: Automatically adjusts the number of web servers based on traffic.
- **Security Groups**: Controls incoming and outgoing traffic to the web servers.


## 🚀 Application Tier

The Application Tier hosts the application servers responsible for running business logic and interacting with the database tier. Key components include:

- **Application Servers**: These run your application code and can be horizontally scaled.
- **Load Balancer**: Distributes traffic to the application servers.
- **Auto Scaling**: Automatically adjusts the number of web servers based on traffic.
- **Security Groups**: Controls incoming and outgoing traffic to the application servers.


## 💽 Database Tier

The Database Tier stores and manages our application data. We use Amazon RDS for a managed database service. Key components include:

- **Amazon RDS**: A managed database service for MySQL/PostgreSQL/SQL Server databases.
- **Security Groups**: Control incoming and outgoing traffic to the database.

## 🔧 Terraform Configuration

The Terraform configuration for this project is organized into different and resources to create the necessary AWS infrastructure components. Key resources include:

- Virtual Private Cloud (VPC)
- Subnets and Route Tables
- Security Groups and Network ACLs
- Load Balancers
- Auto Scaling Groups
- RDS Database Instances

![image](https://github.com/comet1019/3tier-terraform/assets/102784820/76a10e6c-99e5-453d-833c-ad0a3399b904)


## 🚀 Deployment

Follow these steps to deploy the architecture:

1. Clone the repository:

   ```bash
   git clone https://github.com/mathesh-me/multi-tier-architecture-using-terraform.git
   ```

2. Make changes as per your needs.
3. Initialize Terraform and apply the configuration:
   ```
   terraform init
   ```
4. Review the changes and confirm.

## 💼 Usage

### Scaling
- To scale the Web or Application Tier, use Auto Scaling configurations provided in the respective Terraform files. Adjust the desired capacity to match your scaling requirements.
### Database Management
- Access the Amazon RDS instance in the Database Tier to manage your data.
### Load Balancing
- Configure the load balancer in the Web and Application Tiers to distribute traffic evenly.
### Security Considerations
- Review and customize the security groups and network ACLs to meet your specific security requirements.

## 🤝 Contributing
Contributions are Welcome! Please read my Contributing Guidelines to get started with contributing to this project.

## 📄 License
This project is licensed under the MIT License.
