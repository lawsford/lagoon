terraform {
  required_providers {
    kind = {
      source = "tehcyx/kind"
      version = "0.4.0"
    }
  }
}

resource "kind_cluster" "default" {
  name           = var.cluster_name
  wait_for_ready = true

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    node {
      role = "control-plane"
      kubeadm_config_patches = [
          "kind: InitConfiguration\nnodeRegistration:\n  kubeletExtraArgs:\n    node-labels: \"ingress-ready=true\"\n"
      ]
      extra_port_mappings {
        container_port = 30000
        host_port      = 30000
        protocol       = "TCP"
      }
      extra_port_mappings {
        container_port = 80
        host_port      = 80
        protocol       = "TCP"
      }
      extra_port_mappings {
        container_port = 443
        host_port      = 443
        protocol       = "TCP"
      }
      extra_mounts {
        host_path      = "../cluster-volume/control-plane"
        container_path = "/workspace"
      }
    }

    node {
      role = "worker"
      extra_mounts {
        host_path      = "../cluster-volume/worker1"
        container_path = "/workspace"
      }
    }

    node {
      role = "worker"
      extra_mounts {
        host_path      = "../cluster-volume/worker2"
        container_path = "/workspace"
      }
    }

    node {
      role = "worker"
      extra_mounts {
        host_path      = "../cluster-volume/worker3"
        container_path = "/workspace"
      }
    }
  }
}
