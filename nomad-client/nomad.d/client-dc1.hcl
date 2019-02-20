datacenter = "dc1"

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
