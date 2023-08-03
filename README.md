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

5. Use Makefile

With the Makefile and README.md in place, developers using Linux can easily understand the purpose of the repository, its prerequisites, and how to use the provided make targets to create and destroy the WordPress infrastructure. The README.md file also provides instructions on how to set up the required dependencies and where to place the WordPress files for the Ansible playbook to use.

6.  MIT License

Copyright (c) 2023 Dimitar

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
