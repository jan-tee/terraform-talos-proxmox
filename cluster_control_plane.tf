data "talos_machine_configuration" "control_plane" {
  # ensure DNS A records resolve for all control plane nodes
  lifecycle {
    precondition {
      condition     = length(local.dns_missing) == 0
      error_message = "Some expected IPs are missing from DNS resolution for ${var.cluster.endpoint.dns}."
    }

    precondition {
      condition     = length(local.dns_extra) == 0
      error_message = "Some extra IPs are contained in the cluster DNS endpoint: ${var.cluster.endpoint.dns}."
    }
  }

  for_each = local.control_plane_nodes
    cluster_name     = var.cluster.name
    cluster_endpoint = "https://${var.cluster.endpoint.dns}:6443"
    machine_type     = "controlplane"
    machine_secrets  = talos_machine_secrets.machine_secrets.machine_secrets
    config_patches   = local.control_plane_config_patches_yaml
}

# apply machine config to every control plane node
resource "talos_machine_configuration_apply" "control_plane" {
  depends_on = [ proxmox_virtual_environment_vm.control_plane ]
  for_each = local.control_plane_nodes
    client_configuration        = talos_machine_secrets.machine_secrets.client_configuration
    machine_configuration_input = data.talos_machine_configuration.control_plane[each.key].machine_configuration
    node                        = each.value.ip
    config_patches              = local.control_plane_config_patches_yaml
}

# bootstrapping is a one-time, single-node only operation on a control plane node.
resource "talos_machine_bootstrap" "bootstrap" {
  depends_on           = [ talos_machine_configuration_apply.control_plane ]
  client_configuration = talos_machine_secrets.machine_secrets.client_configuration
  node                 = local.control_plane_node_ips[0]
}
