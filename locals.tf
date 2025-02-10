locals {
  _all_nodes = flatten([
    for pool in var.node_pools :            # for each pool...
    [
      for i in range(pool.size) :           # ...for each node in the pool to be generated...
        merge(
          {
            i = i                             # create a map that has i = index,
          },
            pool,                             # all the data from "pool",
          {
            name = "${var.cluster.name}-${pool.name}-${i}",       # node name
            node =  coalesce(pool.node,
              var.cluster.defaults.node),
            node_labels = coalesce(pool.node_labels, [])          # the node label
            vlan_id = try(
              coalesce(pool.vlan_id,
                var.cluster.defaults.vlan_id),
              null),                                              # the VLAN ID
            storage_id = coalesce(pool.storage_id,
              var.cluster.defaults.storage_id),
            cloud_config_storage_id = coalesce(
              pool.cloud_config_storage_id,
              var.cluster.defaults.cloud_config_storage_id,
              var.cluster.defaults.storage_id),
            memory = coalesce(
              pool.memory,
              var.cluster.defaults.memory),
            cpu_type = coalesce(
              pool.cpu_type,
              var.cluster.defaults.cpu_type)
            cpu_cores = coalesce(
              pool.cpu_cores,
              var.cluster.defaults.cpu_cores)
            cpu_sockets = coalesce(
              pool.cpu_type,
              var.cluster.defaults.cpu_sockets)
            network_bridge = coalesce(
              pool.network_bridge,
              var.cluster.defaults.network_bridge),
            on_boot = coalesce(
              pool.on_boot,
              var.cluster.defaults.on_boot,
              false)
            searchdomain = coalesce(
              pool.searchdomain,
              var.cluster.defaults.searchdomain,
              var.cluster.defaults.domain),
            domain = coalesce(
              pool.domain,
              var.cluster.defaults.domain),
            nameservers = coalesce(
              pool.nameservers,
              var.cluster.defaults.nameservers),
            ip = cidrhost(
              coalesce(pool.subnet,
                var.cluster.defaults.subnet),
                i + pool.ip_offset),
            subnet = coalesce(pool.subnet,
                var.cluster.defaults.subnet),
            gw = coalesce(pool.gw,
              var.cluster.defaults.gw)
          }
        )
    ]
  ])

  # and turn that into a flat collection of the properties, and calculate the IP
  worker_nodes = {
    for node in local._all_nodes : node.name =>
        node if node.type == "worker"
    }
  worker_node_ips = [for node in local.worker_nodes : node.ip]

  control_plane_nodes = {
    for node in local._all_nodes : node.name =>
        node if node.type == "control"
    }
  control_plane_node_ips = [for node in local.control_plane_nodes : node.ip]
}
