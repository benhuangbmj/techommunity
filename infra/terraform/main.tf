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
  owner = var.github_owner
}

data "github_repository" "this" {
  full_name = "${var.github_owner}/${var.repo_name}"
}

resource "github_branch_protection" "main" {
  repository_id = data.github_repository.this.node_id
  pattern       = "main"

  enforce_admins                  = true
  required_linear_history         = true
  require_conversation_resolution = true

  required_pull_request_reviews {
    required_approving_review_count = 0
    dismiss_stale_reviews           = true
    # require_code_owner_reviews    = false
  }
}

resource "github_repository_vulnerability_alerts" "this" {
  repository = data.github_repository.this.name
}

resource "github_repository_security_and_analysis" "this" {
  repository = data.github_repository.this.name

  security_and_analysis {
    dependabot_security_updates {
      status = "enabled"
    }
  }
}

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
