resource "aws_iam_role" "ecomm-cluster" {
  name = var.master_role_name

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "ecomm-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.ecomm-cluster.name
}

resource "aws_iam_role_policy_attachment" "ecomm-cluster-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.ecomm-cluster.name
}

resource "aws_eks_cluster" "ecomm" {
  name     = var.cluster-name
  role_arn = aws_iam_role.ecomm-cluster.arn


  vpc_config {
    security_group_ids = [var.eks_sg, var.mongo_sg, var.elb_sg]
    subnet_ids         = data.aws_subnet.ecomm[*].id
    endpoint_private_access = tobool(var.endpoint_private_access)
    endpoint_public_access  = tobool(var.endpoint_public_access)
  }

 
}
