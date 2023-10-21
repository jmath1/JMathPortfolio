output "registry_arn" {
  value = aws_ecr_repository._.arn
}

output "registry_url" {
  value = aws_ecr_repository._.repository_url
}