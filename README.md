I build this project to learn Supabase, npm, monorepo, IaC (via Terraform and Pulumi), GitHub Actions, and other tooling.

## GitOps with Terraform

This repo includes a minimal Terraform setup to manage the repository configuration itself via GitHub Actions.

What you get:
- Terraform plan on Pull Requests that change `infra/terraform/**`
- Terraform apply on merges to `main`

Files:
- `.github/workflows/terraform.yml` – CI workflow for plan/apply
- `infra/terraform` – Terraform config that targets this repository

Setup:
1) Ensure Actions can manage repo settings. By default the `GITHUB_TOKEN` works for many read actions, but for write operations on certain org settings you may need a fine-scoped PAT as a repository secret named `GH_TOKEN` or `ACTIONS_DEPLOY_KEY`. This scaffold uses the default `GITHUB_TOKEN`. If you hit permission errors, create a classic PAT with `repo` scope (and org admin:write if needed) and add it as `GH_TOKEN`. Then set `env` for the steps that need it: `GITHUB_TOKEN: ${{ secrets.GH_TOKEN }}`.
2) Open a PR that modifies files under `infra/terraform/`. The workflow will run `plan` and post a comment.
3) Merge to `main` to auto-apply.

Local usage (optional):
1) Install Terraform >= 1.5
2) Export env vars and run init/plan:
	- `export GITHUB_TOKEN=...` (use a PAT or a fine-grained token)
	- `terraform -chdir=infra/terraform init`
	- `terraform -chdir=infra/terraform plan -var="github_owner=<owner>" -var="repo_name=<this-repo-name>"`

Notes:
- The Terraform config references the existing repository via a data source. Add resources (e.g., branch protections, rulesets) to manage settings in a safe, declarative way.