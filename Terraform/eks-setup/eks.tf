# EKS Cluster
resource "aws_eks_cluster" "eks" {
  name     = "${var.name}-cluster"
  role_arn = aws_iam_role.cluster.arn
  version  = "${var.k8s_version}"
  

  vpc_config {
    # security_group_ids      = [aws_security_group.eks_cluster.id, aws_security_group.eks_nodes.id]
    subnet_ids              = flatten([aws_subnet.public[*].id, aws_subnet.private[*].id])
    endpoint_private_access = true
    endpoint_public_access  = true
    public_access_cidrs     = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags
  )

  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy
  ]
}


# EKS Cluster IAM Role
resource "aws_iam_role" "cluster" {
  name = "${var.name}-Cluster-Role"

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

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}


# EKS Cluster Security Group
resource "aws_security_group" "eks_cluster" {
  name        = "${var.name}-cluster-sg"
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.eks.id

  tags = {
    Name = "${var.name}-cluster-sg"
  }
}

resource "aws_security_group_rule" "cluster_inbound" {
  description              = "Allow worker nodes to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster.id
  source_security_group_id = aws_security_group.eks_nodes.id
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "cluster_outbound" {
  description              = "Allow cluster API Server to communicate with the worker nodes"
  from_port                = 1024
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster.id
  source_security_group_id = aws_security_group.eks_nodes.id
  to_port                  = 65535
  type                     = "egress"
}

resource "time_sleep" "wait_2_min" {
  depends_on = [aws_eks_node_group.ng2]
  create_duration = "30s"
}


data "aws_eks_cluster_auth" "cluster" {
  depends_on = [ aws_eks_node_group.ng1 ]
  name = aws_eks_cluster.eks.name
}

locals {
  depends_on = [ data.aws_eks_cluster_auth.cluster ]
  kubeconfig = templatefile("templates/kubeconfig.tpl", {
    cluster_name                      = aws_eks_cluster.eks.name
    cluster_endpoint                  = aws_eks_cluster.eks.endpoint
    cluster_ca_certificate            = aws_eks_cluster.eks.certificate_authority[0].data
    cluster_token                     = data.aws_eks_cluster_auth.cluster.token
})
  }

resource "local_file" "kubeconfig" {
  content  = local.kubeconfig
  filename = "../kubeconfig"
}