## DEPLOYING CUSTOM VPC USING TERRAFORM
In the age of cloud migration, establishing resilient and secure Virtual Private Cloud (VPC) networks is paramount. AWS offers a robust VPC service, enabling users to craft virtual networks in the cloud. However, configuring and managing a VPC can be complex and time-consuming. Terraform plays a key role. Terraform is an open-source infrastructure as a code tool that steps in to simplify and automate the creation and management of AWS resources.

# The provided main.tf Terraform configuration will create the following AWS resources:
- A Virtual Private Cloud with the specified CIDR block
- Two public subnets, with each subnet associated with a specific availability zone
- Two private subnets, with each subnet associated with a specific availability zone
- Route Table Associations for Public Subnets
- Route Table Associations for Private Subnets
- Internet Gateway (IGW)
- Elastic IP (EIP) for NAT Gateway
- NAT Gateway
- Route Table for Private Subnets: A dedicated route table for private subnets, which routes outbound traffic through the NAT Gateway
- Route Table for Public Subnets: A dedicated route table for public subnets, which routes outbound traffic to the Internet Gateway for internet-bound communicatio

# command
- on the working directory, Run;
1. terraform init
2. terraform validate
3. terraform plan
4. terraform apply

