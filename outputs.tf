output "kubeconfig" {
  description = "ID of the Docker container"
  value       = kind_cluster.default.kubeconfig
}