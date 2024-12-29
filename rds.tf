# RDS Subnet Group
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = [local.private_subnet_1_id, local.private_subnet_2_id]

  tags = {
    Name = "rds-subnet-group"
  }
}

# RDS Security Group
resource "aws_security_group" "rds_sg" {
  name        = "rds-security-group"
  description = "Allow access to RDS"
  vpc_id      = module.aws_vpc.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-sg"
  }
}

# Primary RDS Instance (Writer)
resource "aws_db_instance" "primary" {
  identifier              = "postgres-primary-instance"
  engine                  = "postgres"
  engine_version          = "16.3"                 # Adjust as needed
  instance_class          = "db.t3.micro"          # Use t3.micro or t2.micro for cost-effectiveness
  allocated_storage       = 20                     # Adjust as per requirements
  username                = "masteruser"           # Set this to a secure username
  password                = "password123"          # Replace with a secure password
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  skip_final_snapshot     = true
  publicly_accessible     = false
  multi_az                = false                  # For cost-effective setup, set to true if high availability is needed
  backup_retention_period = 1                      # Set retention period for automated backups (required for replicas)

  tags = {
    Name = "postgres-primary-instance"
  }
}

# Read Replica RDS Instance (Reader)
resource "aws_db_instance" "replica" {
  identifier              = "postgres-replica-instance"
  engine                  = "postgres"
  instance_class          = "db.t3.micro"          # Match with primary instance class
  replicate_source_db     = aws_db_instance.primary.arn
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  publicly_accessible     = false
  depends_on              = [aws_db_instance.primary]  # Ensure replica is created after primary

  tags = {
    Name = "postgres-replica-instance"
  }
}

