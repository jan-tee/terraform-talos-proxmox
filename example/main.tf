module "talos-proxmox" {
  source = "../"

  proxmox = {
    endpoint = var.pm_api_url
    api_token = "${var.pm_api_token_id}=${var.pm_api_token_secret}"
  }

  overwrite_files = true            # set to true to overwrite the downloaded ISO image

  cluster = {
    name = "lisa"
    endpoint = {
      dns = "lisa.k8s.lab"          # DNS name that resolves to the IPs of the control plane nodes
      ip = "10.10.4.100"            # virtual IP for control plane (using built-in load balancer in Talos)
    }
    defaults = {
      node = "laszlo"               # PVE node to deploy on
      cpu_cores = 4                 # default number of CPU cores
      storage_id = "vms-01"         # default storage ID to deploy VMs to
      nameservers = ["10.10.0.1"]   # default nameservers
      searchdomain = "k8s.lab"      # default searchdomain
      domain = "k8s.lab"            # default domain
      subnet = "10.10.0.0/16"       # default subnet
      gw = "10.10.0.1"              # default default gateway
      vlan_id = 1                   # default VLAN ID (remove for no VLAN)
      on_boot = true                # set to true to start VM on boot
    }
  }

  node_pools = [
    {
      name = "cp"                   # prefix for these nodes
      type = "control"              # 'control' for control plane nodes, 'worker' (or do not specify) for workers
      size = 3                      # count
      disk_size = 20                # disk size in GB
      memory = 4096                 # memory size in MB
      ip_offset = 256 * 4 + 1       # IP offset relative to subnet start
    },
    {
      name = "worker-l-afanas"      # a worker pool for 'L' sized workers
      cpu_cores = 6                 # CPU cores
      node = "afanas"               # on PVE cluster node 'afanas'
      size = 10                     # 10 nodes total size of pool
      memory = 8192                 # 8 GB memory
      disk_size = 20                # 20 GB disk
      ip_offset = 256 * 5 + 1       # 10.10.5.1-10
    }
  ]
}

output "talosconfig" {
  value = module.talos-proxmox.talosconfig
  sensitive = true
}

output "kubeconfig" {
  value = module.talos-proxmox.kubeconfig
  sensitive = true
}
