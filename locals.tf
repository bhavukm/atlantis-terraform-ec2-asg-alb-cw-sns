locals {
  project_name = "demo"
  common_tags = {
    Project = local.project_name
    Env     = "dev"
  }
}
