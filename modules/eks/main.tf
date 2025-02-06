/*
  File: modules/eks/main.tf
  Purpose:
    - Create an Amazon EKS cluster.
    - Create a managed node group associated with the cluster.
  Notes:
    - The cluster and node group names are dynamically generated using
      the provided project and environment names.
    - The cluster uses the specified subnets (typically the public subnets from the VPC module).
*/

resource "aws_eks_cluster" "this" {
  name     = "${var.project_name}-${var.environment_name}-eks"
  role_arn = var.cluster_role_arn
  version  = var.eks_version

  vpc_config {
    subnet_ids              = var.subnet_ids
    endpoint_public_access  = true
    endpoint_private_access = false
  }

  tags = merge(
    var.tags,
    {
      Name      = "${var.project_name}-${var.environment_name}-eks",
      component = "eks"
    }
  )
}

resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.project_name}-${var.environment_name}-node-group"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = var.desired_size
    min_size     = var.min_size
    max_size     = var.max_size
  }

  instance_types = var.instance_types

  tags = merge(
    var.tags,
    {
      Name      = "${var.project_name}-${var.environment_name}-node-group",
      component = "eks-node"
    }
  )
}
