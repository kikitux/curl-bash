datacenter = "dc2"
region = "global"
bind_addr = "0.0.0.0"
data_dir = "/var/lib/nomad"

advertise {
  http = "{{ GetInterfaceIP \"enp0s8\" }}"
  rpc = "{{ GetInterfaceIP \"enp0s8\" }}"
  serf = "{{ GetInterfaceIP \"enp0s8\" }}"
}

server {
  enabled = true
  server_join {
    retry_join = [ "192.168.56.20" ]
    retry_max = 6
    retry_interval = "30s"
  }
}

telemetry {
  collection_interval = "1s"
  disable_hostname = true
  prometheus_metrics = true
  publish_allocation_metrics = true
  publish_node_metrics = true
}
