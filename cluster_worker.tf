data "talos_machine_configuration" "worker" {
  cluster_name     = var.cluster.name
  cluster_endpoint = "https://${var.cluster.endpoint.dns}:6443" 
  machine_type     = "worker"
  machine_secrets  = talos_machine_secrets.machine_secrets.machine_secrets
}

resource "talos_machine_configuration_apply" "worker" {
  depends_on                  = [ proxmox_virtual_environment_vm.worker ]
  for_each = local.worker_nodes
    client_configuration        = talos_machine_secrets.machine_secrets.client_configuration
    machine_configuration_input = data.talos_machine_configuration.worker.machine_configuration
    node                        = each.value.ip
    config_patches              = local.worker_config_patches_yaml
}
