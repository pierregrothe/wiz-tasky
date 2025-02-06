/*
  File: modules/eks/outputs.tf
  Purpose:
    - Output key details of the EKS cluster and node group for use in other modules.
*/

output "cluster_name" {
  description = "The name of the EKS cluster."
  value       = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  description = "The endpoint for the EKS cluster."
  value       = aws_eks_cluster.this.endpoint
}

output "cluster_ca_data" {
  description = "The certificate authority data for the EKS cluster."
  value       = aws_eks_cluster.this.certificate_authority[0].data
}

output "node_group_name" {
  description = "The name of the EKS node group."
  value       = aws_eks_node_group.this.node_group_name
}
