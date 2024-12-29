module "eks" {
  source          = "terraform-aws-modules/eks/aws"
   version        = ">= 3.14.2"
  cluster_name    = local.cluster_name
  cluster_version = "1.27"
  subnet_ids      = module.aws_vpc.private_subnets 
  enable_irsa = true
  tags = {
    cluster = "demo"
  }
  vpc_id = module.aws_vpc.vpc_id 
  eks_managed_node_group_defaults = {
    ami_type               = "AL2_x86_64"
    instance_types         = ["t3.medium"]

     #iam_role_arn     = aws_iam_role.eks_worker_role.arn
  }
  eks_managed_node_groups = {
    node_group = {
      min_size     = 2
      max_size     = 6
      desired_size = 2
    } 
  }
}
#aws eks --region <your-region> update-kubeconfig --name <your-cluster-name>
