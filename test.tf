terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

# Configure the GitHub Provider

provider "github" {
  token = var.token
  owner = "Practical-DevOps-GitHub"
}

variable "token" {
  type      = string
  sensitive = true
}

variable "action_token" {
  type      = string
  sensitive = true
}

resource "github_repository" "example" {
  name       = "github-terraform-task-yevheniimovchan"
  visibility = "public"
}

# add user
resource "github_repository_collaborator" "a_repo_collaborator" {
  repository = "https://github.com/Practical-DevOps-GitHub/github-terraform-task-yevheniimovchan.git"
  username   = "softservedata"
  permission = "admin"
}

resource "github_branch" "develop" {
  repository = "https://github.com/Practical-DevOps-GitHub/github-terraform-task-yevheniimovchan.git"
  branch     = "develop"
}

resource "github_branch_default" "default" {
  repository = "https://github.com/Practical-DevOps-GitHub/github-terraform-task-yevheniimovchan.git"
  branch     = github_branch.develop.branch
}
# protected branch
resource "github_branch_protection" "main" {
  repository_id  = "https://github.com/Practical-DevOps-GitHub/github-terraform-task-yevheniimovchan.git"
  pattern        = "main"
  enforce_admins = true

  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    require_code_owner_reviews      = true
    required_approving_review_count = 1
  }
}

resource "github_branch_protection" "develop" {
  repository_id = "https://github.com/Practical-DevOps-GitHub/github-terraform-task-yevheniimovchan.git"
  pattern       = "main"

  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    required_approving_review_count = 2
  }

  enforce_admins = false
}
# pull request
resource "github_repository" "github" {
  name      = "pull_request_template"
  auto_init = true
}
resource "github_repository_file" "github" {
  repository     = "https://github.com/Practical-DevOps-GitHub/github-terraform-task-yevheniimovchan.git"
  file           = ".github/pull_request_template.md"
  content        = "**/*.pull_request_template.md"
  branch         = "main"
  commit_message = "Adding pull request template"
}

# deploy
resource "github_repository_deploy_key" "deploy_key" {
  repository = "https://github.com/Practical-DevOps-GitHub/github-terraform-task-yevheniimovchan.git"
  title      = "DEPLOY_KEY"
  key        = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAgQCwp+ik1N4s0aYouV4kzBXm2SUToRV3Afohs0pcssHwRQWdLiIgfuC9gq9K4WIHVkojDces3TOkM9lTwM4n5Yzie8owa7qkFf66DjTz73a3PlRGY1kI7RJLBjqjUyjRSbBnhHBpYxmhk5jqs2GlMrpBR3ojtRAf3Upi/Hlb2QyW+Q== noname"
}
# webhook

resource "github_repository" "github-terraform-task-yevheniimovchan" {
  name         = "discord"
  homepage_url = "https://discord.com"

  visibility = "public"
}
resource "github_repository_webhook" "discord" {
  repository = "https://github.com/Practical-DevOps-GitHub/github-terraform-task-yevheniimovchan.git"
  configuration {
    url          = "https://discord.com/api/webhooks/1136382484246966343/kn-bCVXIKXGbzwDnJ-7nqAchfhBoa5mzh7kdGjCGfdsgW1GikAFAFe6ddGo7ARtBxVnO"
    content_type = "json"
    insecure_ssl = false
  }
  active = false
  events = ["pull_request"]
}

# pat
resource "github_actions_secret" "pat" {
  repository      = "https://github.com/Practical-DevOps-GitHub/github-terraform-task-yevheniimovchan.git"
  secret_name     = "PAT"
  plaintext_value = var.action_token
}
