# Define VPC using the AWS VPC module
module "aws_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.2"

  name                 = "eks-vpc"
  cidr                 = "10.0.0.0/16"
  azs                  = ["${var.region}a", "${var.region}b"]
  public_subnets       = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets      = ["10.0.3.0/24", "10.0.4.0/24"]
  enable_dns_hostnames = true

# Assign specific subnets by ID to variables or use directly
# Example variables to make referencing specific subnets easier

# Use subnet IDs in other resources
# Elastic IP for NAT Gateway
  tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = 1
  }
}

locals {
  public_subnets_map = {
    "public_1" = module.aws_vpc.public_subnets[0]
    "public_2" = module.aws_vpc.public_subnets[1]
  }
}

# NAT Gateway in Public Subnet for Private Subnet Internet Access
resource "aws_eip" "nat_eip" {
  #depends_on = [aws_internet_gateway.igw]
  domain     = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = local.public_subnet_1_id # Assign to the first public subnet

  tags = {
    Name = "eks-nat-gateway"
  }
}

locals {
  private_subnets_map = {
    "private_1" = module.aws_vpc.private_subnets[0]
    "private_2" = module.aws_vpc.private_subnets[1]
  }
}

