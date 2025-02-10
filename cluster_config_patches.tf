locals {
  worker_config_patches_yaml = split(yamlencode(
    {
     "machine": {
      "features": {
        "kubePrism": {
          "enabled": true,
          "port": 7445
        }
      },
      "logging": {
        "destinations": [
          {
            "endpoint": "udp://127.0.0.1:12345/",
            "format": "json_lines"
          }
        ],
        "extraTags": {
          "cluster": var.cluster.name
        }
      },
    }
  }), "\n")

  control_plane_config_patches_yaml = split(yamlencode(
    {
     "machine": {
      "features": {
        "kubePrism": {
          "enabled": true,
          "port": 7445
        }
      },
      "logging": {
        "destinations": [
          {
            "endpoint": "udp://127.0.0.1:12345/",
            "format": "json_lines"
          }
        ],
        "extraTags": {
          "cluster": var.cluster.name
        }
      },
    }
  }), "\n")
}
