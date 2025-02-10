# Talos Linux on Proxmox

A Terraform provider to install Talos Linux clusters on Proxmox and
bootstrap Kubernetes and add/remove nodes and node pools over time.

Features:

 - supports control plane redundancy - 1, 3, 5 nodes.
 - allows multiple node pools to be defined
 - supports multi-node Proxmox clusters
 - checks for existence of the control plane DNS record, and that it maps to
   all control plane endpoints

See the [example/](example/) for how to create your own cluster quickly. The
easiest way to pass credentials to the `proxmox` module is by setting env
vars and setting up permissions for an SSH user on your Proxmox node(s):

1. On the Terrform host, set up your profile or other method to set env vars:
   ```bash
    export TF_VAR_pm_api_url="https://<my_proxmox_node>:8006/api2/json"
    export TF_VAR_pm_api_token_id="root@pam!terraform"
    export TF_VAR_pm_api_token_secret="<secret>"```

1. In accordance with the reasons set out
   [here](https://github.com/bpg/terraform-provider-proxmox/blob/main/docs/index.md),
   make sure to create a SSH user for this Terraform project to use on the
   Proxmox (PVE) cluster nodes. There are ways around this, but it is much more
   comfortable to set it up this way:  
   ```bash
   sudo useradd -m terraform
   cat > /etc/sudoers.d/terraform <<EOM
   terraform ALL=(root) NOPASSWD: /sbin/pvesm
   terraform ALL=(root) NOPASSWD: /sbin/qm
   terraform ALL=(root) NOPASSWD: /usr/bin/tee /var/lib/vz/*
   EOM```

1. Add your SSH key to the `authorized_keys` of the `terraform` user on all
   relevant nodes of your Proxmox (PVE) cluster.

1. Make this SSH key available on the Terraform host via `ssh-agent` (`ssh-add ...`).
