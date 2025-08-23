terraform {
  required_version = ">= 1.5.0"
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

provider "github" {
  # Authentication via GITHUB_TOKEN or personal access token.
  # The GitHub Actions workflow will supply this automatically.
  owner = var.github_owner
}

# Reference the existing repository so Terraform can attach configuration
data "github_repository" "this" {
  full_name = "${var.github_owner}/${var.repo_name}"
}

# Add resources that configure this existing repo (safe GitOps pattern).
# Examples you can enable later:
#
# resource "github_branch_protection" "main" {
#   repository_id  = data.github_repository.this.node_id
#   pattern        = "main"
#   required_status_checks {
#     strict   = true
#     contexts = []
#   }
#   enforce_admins                  = true
#   required_linear_history         = true
#   require_conversation_resolution = true
# }

# resource "github_repository_ruleset" "required_reviews" {
#   name        = "Require reviews"
#   repository  = data.github_repository.this.name
#   target      = "branch"
#   enforcement = "active"
#   rules {
#     pull_request {
#       require_code_owner_review = true
#       required_approving_review_count = 1
#     }
#   }
#   conditions {
#     ref_name {
#       include = ["refs/heads/main"]
#       exclude = []
#     }
#   }
# }
