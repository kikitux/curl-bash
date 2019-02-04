{
  "datacenter": "dc1",
  "server": false,
  "ui": false,
  "advertise_addr": "{{ GetInterfaceIP \"enp0s8\" }}",
  "client_addr": "0.0.0.0",
  "bind_addr": "0.0.0.0",
  "data_dir": "/usr/local/consul",
  "retry_join": [
    "192.168.56.20"
  ]
}
