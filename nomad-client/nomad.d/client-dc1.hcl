datacenter = "dc1"
region = "global"

client {
  network_interface = "enp0s8"
  enabled = true
  server_join {
    retry_join = [ "192.168.56.20" ]
    retry_max = 5
    retry_interval = "15s"
  }
  options = {
    "driver.raw_exec" = "1"
    "driver.raw_exec.enable" = "1"
    "driver.raw_exec.no_cgroups" = "1"
  }
}

bind_addr = "0.0.0.0"
data_dir = "/var/lib/nomad"

advertise {
  # This should be the IP of THIS MACHINE and must be routable by every node
  # in your cluster
  http = "{{ GetInterfaceIP \"enp0s8\" }}"
  rpc = "{{ GetInterfaceIP \"enp0s8\" }}"
  serf = "{{ GetInterfaceIP \"enp0s8\" }}"
}

telemetry {
  collection_interval = "1s"
  disable_hostname = true
  prometheus_metrics = true
  publish_allocation_metrics = true
  publish_node_metrics = true
}
