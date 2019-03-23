datacenter = "dc2"
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
    retry_max = 5
    retry_interval = "15s"
  }
}

telemetry {
  collection_interval = "1s"
  disable_hostname = true
  prometheus_metrics = true
  publish_allocation_metrics = true
  publish_node_metrics = true
}
