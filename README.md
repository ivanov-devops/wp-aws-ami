# Terraform AWS Infrastructure

This repository is PoC and contains Terraform and Ansible code to set up a WordPress infrastructure on AWS with the website, custom front page and cron which makes OPTIMIZE for all tables in the database and record before and after the OPTIMIZE the size of the tables in log file.

## Prerequisites

Before running Terraform, ensure you have the following:

1. AWS Account: You need an AWS account with appropriate access to create resources.

2. AWS CLI: Install the AWS CLI on your Linux machine. You can follow the official guide [here](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html).

3. Terraform: Install Terraform on your Linux machine. You can download the latest version from the official website [here](https://www.terraform.io/downloads.html) or use package managers like `apt` or `yum`.

4. Ansible
#### Linux (Red Hat/CentOS)

On Red Hat-based systems like CentOS, you can use the following commands to install Ansible:

```bash
sudo yum install epel-release   # Install the EPEL repository (if not already installed)
sudo yum install ansible
```
#### macOS
```
pip3 install ansible
```
#### check with
```
ansible --version
```

5. AWS Credentials: Configure your AWS credentials on your Linux machine by creating a shared credentials file. Open a terminal and run:

   ```
   bash
   mkdir ~/.aws
   touch ~/.aws/credentials
   echo "[default]" >> ~/.aws/credentials
   echo "aws_access_key_id = YOUR_ACCESS_KEY" >> ~/.aws/credentials
   echo "aws_secret_access_key = YOUR_SECRET_KEY" >> ~/.aws/credentials
   ```
6. Make: Make is a build automation tool that simplifies the process of building and compiling code. It is usually pre-installed on Unix-based systems like Linux and macOS. For Windows users, you can install Make through tools like Cygwin or WSL.

Installation:
   For Linux (Ubuntu/Debian): sudo apt-get install make
   For macOS (Homebrew): brew install make

jq: jq is a lightweight and flexible command-line JSON processor. It is used to parse, filter, and manipulate JSON data in the terminal.

Installation:
   For Linux (Ubuntu/Debian): sudo apt-get install jq
   For macOS (Homebrew): brew install jq
   For Windows: Download the binary from the official jq website (https://stedolan.github.io/jq/download/)


#### USAGE

Terraform will provision the resources.

Ansible is used to:
- attach the EFS, update the nodes, deploy mysql in database ec2
- deploy Apache and wordpress
- install the wp and cron
- add custom page to the current default theme via wp cli

update in `makefile` `AWS_PROFILE :=` with your aws AWS_PROFILE

and just run
`make provision`

# Terraform Provisioned Resources

## VPC

### wordpress-vpc

- CIDR Block: 10.0.0.0/16
- Availability Zones: us-east-2a, us-east-2b
- Public Subnets: [Subnet IDs]
- Enable DNS Hostnames: true

## EC2 Instances

### wordpress-instance-1

- AMI: [AMI ID]
- Instance Type: t2.micro
- Subnet: [Subnet ID]
- Public IP: [Public IP Address]
- Key Pair: wordpress-key

### wordpress-instance-2

- AMI: [AMI ID]
- Instance Type: t2.micro
- Subnet: [Subnet ID]
- Public IP: [Public IP Address]
- Key Pair: wordpress-key

### database-instance

- AMI: [AMI ID]
- Instance Type: t2.micro
- Subnet: [Subnet ID]
- Public IP: [Public IP Address]
- Key Pair: wordpress-key

## Security Groups

### Default Security Group

- Allow Inbound: Port 22 (SSH) from 0.0.0.0/0
- Allow Inbound: Port 80 (HTTP) from 0.0.0.0/0
- Allow Outbound: All Traffic to 0.0.0.0/0

### ALB Security Group

- Allow Inbound: Port 80 (HTTP) from Default Security Group

## Load Balancer

### wordpress-alb

- Subnets: [Subnet IDs]
- Security Groups: [ALB Security Group ID]

## Load Balancer Target Group

### wordpress-target-group

- Protocol: HTTP
- Health Check: Path: /, Port: traffic-port

## Load Balancer Listeners

### Listener: wordpress-host-header-rule

- Protocol: HTTP
- Condition: Host Header: wordpress.dext.local
- Action: Forward to wordpress-target-group

### Listener: wordpress-path-rule

- Protocol: HTTP
- Condition: Path Pattern: /wordpress/*
- Action: Forward to wordpress-target-group

## EFS File System

### wordpress-efs

- Creation Token: [Creation Token]
- Lifecycle Policy: [Lifecycle Policy]

## EFS Mount Targets

- Subnets: [Subnet IDs]

## EFS Security Group

- Inbound Rule: Port 2049 (NFS) from Default Security Group

## SSH Private Key

### wordpress-key.pem

- File Location: ../ansible/wordpress-key.pem
- Permissions: 0600

License

This project is licensed under the [MIT License](https://opensource.org/licenses/MIT). Feel free to use, modify, and distribute the code following the terms of the license.
Copyright (c) 2023 Dimitar
