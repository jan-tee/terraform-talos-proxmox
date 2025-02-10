variable "cluster" {
  type = object({
    name                      = string,
    endpoint                  = object({
      dns                     = string
      ip                      = string
    }),
    defaults                  = object({
      node                    = string,
      cpu_type                = optional(string, "max"),
      cpu_cores               = optional(number, 2),
      cpu_sockets             = optional(number, 1),
      storage_id              = optional(string, "local-zfs"),
      cloud_config_storage_id = optional(string),
      searchdomain            = optional(string),
      domain                  = optional(string),
      nameservers             = optional(list(string)),
      subnet                  = optional(string),
      gw                      = optional(string),
      vlan_id                 = optional(number)
      cores                   = optional(number, 2),
      sockets                 = optional(number, 1),
      memory                  = optional(number, 4096),
      disk_size               = optional(number, 20),
      network_bridge          = optional(string, "vmbr0"),
      on_boot                 = optional(bool),
    })
  })
}

variable "overwrite_files" {
  type = bool
  default = true
}

variable "proxmox" {
 type = object({
   endpoint                = string,
   api_token               = string
 })
}

variable "node_pools" {
  description = "Node pool definitions for the cluster."
  type = list(object({
    node            = optional(string),
    pool            = optional(string),

    type            = optional(string, "worker"),

    name            = string,
    size            = number,
    cpu_type        = optional(string),
    cpu_cores       = optional(number),
    cpu_sockets     = optional(number),
    domain          = optional(string),
    searchdomain    = optional(string),
    nameservers     = optional(list(string)),
    gw              = optional(string),
    subnet          = optional(string),
    ip_offset       = number,
    memory          = optional(number),
    disk_size       = optional(number),
    network_bridge  = optional(string),
    vlan_id         = optional(number),
    storage_id      = optional(string),
    cloud_config_storage_id = optional(string),
    on_boot         = optional(bool),
    node_labels     = optional(list(string))
  }))

  validation {
    condition = alltrue([
      for c in var.node_pools : contains(["worker", "control"], c.type)
    ])
    error_message = "Node pool type must be 'control' or 'worker' (default)"
  }

  validation {
    condition = anytrue([
      for c in var.node_pools : contains(["control"], c.type)
    ])
    error_message = "Node pool must contain a control plane"
  }

 
}
