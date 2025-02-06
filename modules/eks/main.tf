// File: modules/eks/main.tf
// ---------------------------------------------------------------------------
// EKS Module for wiz-tasky Project
//
// This module provisions an Amazon EKS cluster along with a managed node group.
// It leverages dynamic naming based on the project and environment values,
// reads configuration from external variables, and applies merged tags for
// consistency across environments.
// ---------------------------------------------------------------------------

/*
  EKS Cluster:
  Purpose:
    - Creates an EKS cluster with the specified Kubernetes version.
    - The cluster is deployed using the provided subnets.
    - The IAM role (cluster_role_arn) used by the cluster is created externally.
    - Tags are merged to include project and environment information.
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

/*
  EKS Managed Node Group:
  Purpose:
    - Creates a managed node group for the EKS cluster.
    - Uses the provided instance types, scaling configuration, and IAM role for nodes.
    - The node group name is dynamically constructed using project and environment values.
    - Tags are applied for identification and resource grouping.
*/
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
