terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.60.0"
    }
    talos = {
      source = "siderolabs/talos"
      version = "0.5.0"
    }
  }
}

provider "proxmox" {
  endpoint  = var.proxmox.endpoint
  api_token = var.proxmox.api_token

  ssh {
    agent = true
    username = "terraform"
  }
}
