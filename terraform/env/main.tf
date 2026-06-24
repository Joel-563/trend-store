terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "../terraform/modules/vpc"

  name       = var.name
  cidr       = var.cidr
  create_igw = var.create_igw

  azs             = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  enable_nat_gateway = true
  single_nat_gateway = true
  tags               = var.tags
}
module "keypair" {
  source = "../terraform/modules/keypair"

  key_pair_name = "${var.name}-keypair"
  rsa_bits      = var.rsa_bits
}
module "ec2_instance" {
  source = "../terraform/modules/EC2"

  ec2_name                     = var.ec2_name
  ami                          = var.ami
  ami_ssm_parameter            = var.ami_ssm_parameter
  instance_type                = var.instance_type
  root_block_device            = var.root_block_device
  associate_public_ip_address  = var.associate_public_ip_address
  create_security_group        = var.create_security_group
  security_group_description   = var.security_group_description
  security_group_name          = var.security_group_name
  security_group_ingress_rules = var.security_group_ingress_rules
  security_group_egress_rules  = var.security_group_egress_rules
  security_group_tags          = var.security_group_tags
  security_group_vpc_id        = module.vpc.vpc_id
  subnet_id                    = module.vpc.public_subnet_ids[0]
  user_data                    = var.user_data
  tags                         = var.tags
  ebs_optimized                = var.ebs_optimized
  create_iam_instance_profile  = var.create_iam_instance_profile
  iam_instance_profile         = var.iam_instance_profile
  iam_role_name                = var.iam_role_name
  iam_role_description         = var.iam_role_description
  iam_role_policies            = var.iam_role_policies
  iam_role_tags                = var.iam_role_tags
  key_name                     = module.keypair.key_pair_name
}
module "eks" {
  source = "../terraform/modules/EKS"

  name                     = "${var.name}-cluster"
  kubernetes_version       = "1.34"
  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnet_ids
  control_plane_subnet_ids = module.vpc.public_subnet_ids
  addons = {
    coredns = {}

    kube-proxy = {}

    eks-pod-identity-agent = {
      before_compute = true
    }

    aws-ebs-csi-driver = {
      pod_identity_association = [{
        role_arn        = module.ebs-pod-identity.iam_role_arn
        service_account = "ebs-csi-controller-sa"
      }]
    }

    vpc-cni = {
      before_compute = true
      pod_identity_association = [{
        role_arn        = module.vpc-cni-pod-identity.iam_role_arn
        service_account = "aws-node"
      }]
    }
  }
  eks_managed_node_groups = {
    worker = {
      name                           = "${var.name}-worker"
      subnet_ids                     = module.vpc.private_subnet_ids
      instance_types                 = ["c7i-flex.large"]
      capacity_type                  = "ON_DEMAND"
      ami_type                       = "AL2023_x86_64_STANDARD"
      use_latest_ami_release_version = true
      disk_size                      = 20
      min_size                       = 1
      max_size                       = 3
      desired_size                   = 1

      iam_role_name              = "worker-node-group-role"
      iam_role_attach_cni_policy = false
      create_security_group      = true

      iam_role_additional_policies = {
        AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
      }

      labels = {
        role = "worker"
      }

      update_config = {
        max_unavailable = 1
      }

      tags = merge(var.tags, {
        Name = "${var.name}-worker"
      })
    }
  }

}
module "ebs-pod-identity" {
  source = "../terraform/modules/eks-pod-identity"

  attach_aws_ebs_csi_policy = true
  name                      = "${var.name}-ebs-role"
}

module "vpc-cni-pod-identity" {
  source = "../terraform/modules/eks-pod-identity"

  attach_aws_vpc_cni_policy = true
  aws_vpc_cni_enable_ipv4   = true
  name                      = "${var.name}-vpc-cni-role"
}
