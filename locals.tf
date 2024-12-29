locals {
  public_subnet_1_id  = module.aws_vpc.public_subnets[0] # First public subnet
  public_subnet_2_id  = module.aws_vpc.public_subnets[1] # Second public subnet
  private_subnet_1_id = module.aws_vpc.private_subnets[0] # First private subnet
  private_subnet_2_id = module.aws_vpc.private_subnets[1] # Second private subnet
}
