resource "talos_machine_secrets" "machine_secrets" {}

data "talos_client_configuration" "talosconfig" {
  cluster_name         = var.cluster.name
  client_configuration = talos_machine_secrets.machine_secrets.client_configuration
  # endpoints            = local.control_plane_node_ips
  endpoints            = local.control_plane_node_ips
}

data "talos_cluster_health" "health" {
  depends_on           = [
    talos_machine_configuration_apply.control_plane,
    talos_machine_configuration_apply.worker
  ]
  client_configuration = data.talos_client_configuration.talosconfig.client_configuration
  control_plane_nodes  = local.control_plane_node_ips
  worker_nodes         = local.worker_node_ips
  endpoints            = data.talos_client_configuration.talosconfig.endpoints
}

data "talos_cluster_kubeconfig" "kubeconfig" {
  depends_on           = [
    talos_machine_bootstrap.bootstrap,
    data.talos_cluster_health.health
  ]
  client_configuration = talos_machine_secrets.machine_secrets.client_configuration
  node                 = local.control_plane_node_ips[0]
}
