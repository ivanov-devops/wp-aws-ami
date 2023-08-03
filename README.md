# Terraform AWS Infrastructure

This repository contains Terraform and Ansible code to set up a WordPress infrastructure on AWS.

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

With the Makefile and terraform can be provisioned the archtecture of:
- VPC
- subnets
- route Tables
- ALB
- EFS
- database ec2 instance
- 2 ec2 wordpress instances

Ansible is used to:
- attach the EFS, update the nodes, deploy mysql in database ec2
- deploy Apache and wordpress
- install the wp
- add custom page to the current default theme via wp cli

or just run
`make provision`

7.  MIT License

Copyright (c) 2023 Dimitar

License

This project is licensed under the MIT License. Feel free to use, modify, and distribute the code following the terms of the license.
