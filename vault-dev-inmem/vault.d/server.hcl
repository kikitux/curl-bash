{
  "ui": true,
  "default_lease_ttl": "168h",
  "max_lease_ttl": "720h",
  "plugin_directory": "/usr/local/vault/plugins",
  "disable_mlock": true
}

storage "inmem" {}

telemetry {
  prometheus_retention_time = "30s",
  disable_hostname = true
}
