locals {
  worker_config_patches_yaml = [
    yamlencode(var.cluster.talos.worker_config_patches)
  ]

  control_plane_config_patches_yaml = [ 
    yamlencode(var.cluster.talos.control_plane_config_patches)
  ]
}
