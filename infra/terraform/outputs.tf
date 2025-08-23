output "repository_id" {
  description = "The ID of the managed repository"
  value       = data.github_repository.this.node_id
}

output "repository_name" {
  description = "The name of the managed repository"
  value       = data.github_repository.this.name
}
