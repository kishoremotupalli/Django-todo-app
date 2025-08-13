output "ecr_url"         { value = aws_ecr_repository.app.repository_url }
output "cluster_name"    { value = module.eks.cluster_name }
output "cluster_endpoint"{ value = module.eks.cluster_endpoint }