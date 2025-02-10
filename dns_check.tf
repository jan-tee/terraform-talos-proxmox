data "dns_a_record_set" "control_plane" {
  host = var.cluster.endpoint.dns
}

output "control_plane_resolved_ips" {
  value = data.dns_a_record_set.control_plane.addrs
}

# Ensure that the resolved IPs match expected values
locals {
  # Ensure all expected IPs are in the resolved set
  dns_missing = setsubtract(local.control_plane_node_ips, data.dns_a_record_set.control_plane.addrs)
  dns_extra   = setsubtract(data.dns_a_record_set.control_plane.addrs, local.control_plane_node_ips)
}
