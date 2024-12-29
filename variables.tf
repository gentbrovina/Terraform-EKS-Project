variable "region" {
  default = "eu-central-1"
}

variable "cluster_name" {
  default = "my-eks-cluster"
}

variable "node_group_name" {
  default = "my-eks-nodes"
}

variable "node_instance_type" {
  default = "t2.small"
}

variable "desired_capacity" {
  default = 2
}

variable "max_size" {
  default = 3
}

variable "min_size" {
  default = 1
}

variable "AMIS" {
  type = map(string)
  default = {
    eu-central-1 = "ami-0eddb4a4e7d846d6f"
  }
}
variable "PRIVATE_KEY" {
  default = "mykey"
}

variable "PUBLIC_KEY" {
  default = "mykey.pub"
}
