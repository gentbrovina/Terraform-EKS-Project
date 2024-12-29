resource "aws_instance" "bastion" {
  ami           = var.AMIS[var.region]
  instance_type = "t2.micro"
  subnet_id = local.public_subnet_1_id 
  vpc_security_group_ids = [aws_security_group.bastion-allow-ssh.id]

  #key_name = aws_key_pair.mykeypair.key_name
}

# EC2 Instances for NATS Cluster
resource "aws_instance" "nats" {
  count                   = 2  # Two instances for redundancy
  ami                     = "ami-0eddb4a4e7d846d6f"  # Replace with appropriate AMI
  instance_type           = "t2.micro"
  subnet_id               = element(module.aws_vpc.private_subnets, count.index)
  vpc_security_group_ids  = [aws_security_group.nats_sg.id]
  #key_name                = "your-key-name"

  tags = {
    Name = "nats-cluster-${count.index + 1}"
  }
}