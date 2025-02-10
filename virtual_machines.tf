resource "proxmox_virtual_environment_vm" "control_plane" {
  for_each    = local.control_plane_nodes

  name        = each.value.name
  description = "Managed by Terraform"
  tags        = ["terraform"]
  node_name   = each.value.node
  on_boot     = each.value.on_boot

  cpu {
    cores = each.value.cpu_cores
    sockets = each.value.cpu_sockets
    type = each.value.cpu_type
  }

  memory {
    dedicated = each.value.memory
  }

  agent {
    enabled = true
  }

  network_device {
    bridge = each.value.network_bridge
    vlan_id = each.value.vlan_id
  }

  disk {
    datastore_id = each.value.storage_id
    file_id      = proxmox_virtual_environment_download_file.talos_nocloud_image.id
    file_format  = "raw"
    interface    = "virtio0"
    size         = 20
  }

  operating_system {
    type = "l26" # Linux Kernel 2.6 - 5.X.
  }

  initialization {
    datastore_id = each.value.cloud_config_storage_id
    dns {
      domain = each.value.searchdomain
      servers = each.value.nameservers
    }
    ip_config {
      ipv4 {
        address = "${each.value.ip}/${split("/", each.value.subnet)[1]}"
        gateway = "${each.value.gw}"      
      }
      ipv6 {
        address = "dhcp"
      }
    }
  }

  lifecycle {
    ignore_changes = [
      initialization[0].datastore_id,
      initialization[0].interface,
      initialization[0].upgrade,
      network_device[0].disconnected,
      network_device[0].mac_address,
      disk[0].file_format,
      disk[0].file_id,
      disk[0].path_in_datastore,
      tags,
      mac_addresses,
      id,
      vm_id,
      cpu[0].flags
    ]
  }
}


resource "proxmox_virtual_environment_vm" "worker" {
  depends_on  = [ proxmox_virtual_environment_vm.control_plane ]
  
  for_each    = local.worker_nodes

  name        = each.value.name
  description = "Managed by Terraform"
  tags        = ["terraform"]
  node_name   = each.value.node
  on_boot     = each.value.on_boot

  cpu {
    cores = each.value.cpu_cores
    sockets = each.value.cpu_sockets
    type = each.value.cpu_type
  }

  memory {
    dedicated = each.value.memory
  }

  agent {
    enabled = true
  }

  network_device {
    bridge = each.value.network_bridge
    vlan_id = each.value.vlan_id
  }

  disk {
    datastore_id = each.value.storage_id
    file_id      = proxmox_virtual_environment_download_file.talos_nocloud_image.id
    file_format  = "raw"
    interface    = "virtio0"
    size         = 20
  }

  operating_system {
    type = "l26" # Linux Kernel 2.6 - 5.X.
  }

  initialization {
    datastore_id = each.value.cloud_config_storage_id
    dns {
      domain = each.value.searchdomain
      servers = each.value.nameservers
    }
    ip_config {
      ipv4 {
        address = "${each.value.ip}/${split("/", each.value.subnet)[1]}"
        gateway = "${each.value.gw}"      
      }
      ipv6 {
        address = "dhcp"
      }
    }
  }

  lifecycle {
    ignore_changes = [
      initialization[0].datastore_id,
      initialization[0].interface,
      initialization[0].upgrade,
      network_device[0].disconnected,
      network_device[0].mac_address,
      disk[0].file_format,
      disk[0].file_id,
      disk[0].path_in_datastore,
      tags,
      mac_addresses,
      id,
      vm_id,
      cpu[0].flags
    ]
  }
}
