locals {
  app_name = "web"
}

module "cluster" {
  source                      = "../ecs_cluster"
  name                        = var.name
  environment                 = var.environment
}

module "roles" {
  source                      = "../ecs_roles"
  environment                 = var.environment
}
