# output "kubeconfig" {
#   description = "ID of the Docker container"
#   value       = kind_cluster.default.kubeconfig
# }

output "cluster_name" {
  description = "The name of the local cluster"
  value       = var.cluster_name
}
