output "repository_names" {
  value = {
    for service, repo in aws_ecr_repository.repositories :
    service => repo.name
  }
}

output "repository_urls" {
  value = {
    for service, repo in aws_ecr_repository.repositories :
    service => repo.repository_url
  }
}

output "repository_arns" {
  value = {
    for service, repo in aws_ecr_repository.repositories :
    service => repo.arn
  }
}
