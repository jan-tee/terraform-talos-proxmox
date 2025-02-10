# Example

This Terraform project will deploy, using the Terraform provider from `..`,
a Talos Linux cluster with Kubernetes.

1. Set up the environment variables and Proxmox (PVE) environment like
   outlined in [the docs](../README.md).

1. Edit `main.tf` to your liking; the defaults will not apply to your
   enviroment unless you randomly happen to have your Proxmox (PVE)
   cluster nodes named just like mine.

1. Run `terraform apply` and device to install.

1. Run `./config.sh my-cluster my-admin` to export commands to import
   configuration for `kubectl` and `talosctl`.

1. Enjoy your cluster!

1. Add/remove nodes to your liking as needs change, and re-run `terraform
   apply`
