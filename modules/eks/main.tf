resource "aws_eks_cluster" "eks" {
  name     = "${var.vpc_id}-eks-cluster"
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids = var.private_subnet_ids
  }

  tags = {
    Name        = "${var.vpc_id}-eks-cluster"
    Environment = "production"
  }
}
