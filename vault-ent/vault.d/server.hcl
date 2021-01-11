{
  "ui": true,
  "backend": {
    "consul": {
      "address": "http://localhost:8500",
      "path": "vault/"
    }
  },
  "default_lease_ttl": "168h",
  "max_lease_ttl": "720h",
  "plugin_directory": "/usr/local/vault/plugins",
  "disable_mlock": true
}

telemetry {
  prometheus_retention_time = "30s",
  disable_hostname = true
}

listener "tcp" {
  address = "0.0.0.0:8200"
  tls_disable = true
}

seal "transit" {
  address            = "http://vault01-unsealer:8200"
  token              = "changeme"
  disable_renewal    = "false"
  key_name           = "unseal_key"
  mount_path         = "transit/"
}

cluster_name = "primary"
api_addr="http://0.0.0.0:8200"
cluster_addr="http://0.0.0.0:8201"
