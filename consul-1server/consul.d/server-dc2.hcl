{
  "datacenter": "dc2",
  "server": true,
  "ui": true,
  "client_addr": "0.0.0.0",
  "bind_addr": "{{ GetInterfaceIP \"enp0s8\" }}",
  "data_dir": "/usr/local/consul",
  "bootstrap_expect": 1,
  "retry_join_wan": [
    "192.168.56.20"
  ]
}
