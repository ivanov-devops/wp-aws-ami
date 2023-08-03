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

   ```bash
   mkdir ~/.aws
   touch ~/.aws/credentials
   echo "[default]" >> ~/.aws/credentials
   echo "aws_access_key_id = YOUR_ACCESS_KEY" >> ~/.aws/credentials
   echo "aws_secret_access_key = YOUR_SECRET_KEY" >> ~/.aws/credentials

5. Use Makefile

LICENSE

Replace `https://github.com/your-username/terraform-aws-infrastructure.git` in the `git clone` command with the actual URL of your repository if it's hosted on a remote Git service.

With the Makefile and README.md in place, developers using Linux can easily understand the purpose of the repository, its prerequisites, and how to use the provided make targets to create and destroy the WordPress infrastructure. The README.md file also provides instructions on how to set up the required dependencies and where to place the WordPress files for the Ansible playbook to use.
