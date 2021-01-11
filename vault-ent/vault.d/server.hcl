storage "consul" {
  address = "127.0.0.1:8500"
  path    = "vault"
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
disable_mlock = true
api_addr="http://0.0.0.0:8200"
cluster_addr="http://0.0.0.0:8201"
