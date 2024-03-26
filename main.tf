module "kind" {
  source = "./modules/kind"
  cluster_name = "local"
}

module "kubernetes" {
  source      = "./modules/kubernetes"
  config_path = "./${module.kind.cluster_name}-config"
}