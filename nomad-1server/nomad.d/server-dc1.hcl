bind_addr = "0.0.0.0"
data_dir = "/var/lib/nomad"

advertise {
  rpc = "{{ GetInterfaceIP \"enp0s8\" }}"
}

server {
  enabled = true
  bootstrap_expect = 3
  server_join {
    retry_max = 5
    retry_interval = "15s"
  }
}
