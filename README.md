# curl-bash

A set of scripts that can be used to bootstrap dev environments in the `curl | sudo bash` way.

The scripts will download any file that is required, making the script portable, and to be able to use them remotely.

The scripts require root as we will register the services (when appropiate) with systemd.

## consul

### consul-1server
[consul-1server/consul.sh](https://raw.githubusercontent.com/kikitux/curl-bash/master/consul-1server/consul.sh)

input:
- variable `IFACE` the interface to bind, defaults to `ens0p8`
- variable `DC` name of dc, defaults to `dc1`
- variable `WAN_JOIN` ip of first dc, defaults to `192.168.56.20`

shell
```bash
curl https://raw.githubusercontent.com/kikitux/curl-bash/master/consul-1server/consul.sh | sudo bash 
```

vagrant
```ruby
config.vm.provision "shell", path: "https://raw.githubusercontent.com/kikitux/curl-bash/master/consul-1server/consul.sh"
```

### consul-client
[consul-client/consul.sh](https://raw.githubusercontent.com/kikitux/curl-bash/master/consul-client/consul.sh)

input:
- variable `IFACE` the interface to bind, defaults to `ens0p8`
- variable `DC` name of dc, defaults to `dc1`
- variable `LAN_JOIN` ip of server, defaults to `192.168.56.20`

shell
```bash
curl https://raw.githubusercontent.com/kikitux/curl-bash/master/consul-client/consul.sh | sudo bash
```

vagrant
```ruby
config.vm.provision "shell", path: "https://raw.githubusercontent.com/kikitux/curl-bash/master/consul-client/consul.sh"
```

## nomad

### nomad-1server
[nomad-1server/nomad.sh](https://raw.githubusercontent.com/kikitux/curl-bash/master/nomad-1server/nomad.sh)

input:
- variable `IFACE` the interface to bind, defaults to `ens0p8`
- variable `DC` name of dc, defaults to `dc1`
- variable `WAN_JOIN` ip of first dc, defaults to `192.168.56.20`

shell
```bash
curl https://raw.githubusercontent.com/kikitux/curl-bash/master/nomad-1server/nomad.sh | sudo bash 
```

vagrant
```ruby
config.vm.provision "shell", path: "https://raw.githubusercontent.com/kikitux/curl-bash/master/nomad-1server/nomad.sh"
```

### nomad-client
[nomad-client/nomad.sh](https://raw.githubusercontent.com/kikitux/curl-bash/master/nomad-client/nomad.sh)

input:
- variable `IFACE` the interface to bind, defaults to `ens0p8`
- variable `DC` name of dc, defaults to `dc1`
- variable `LAN_JOIN` ip of server, defaults to `192.168.56.20`

shell
```bash
curl https://raw.githubusercontent.com/kikitux/curl-bash/master/nomad-client/nomad.sh | sudo bash
```

vagrant
```ruby
config.vm.provision "shell", path: "https://raw.githubusercontent.com/kikitux/curl-bash/master/nomad-client/nomad.sh"
```


## vault

### vault-dev
[vault-dev/vault.sh](https://raw.githubusercontent.com/kikitux/curl-bash/master/vault-dev/vault.sh)

Vault requires a consul-client installed for backend. Run this script after consul cluster has been created.

shell
```bash
curl https://raw.githubusercontent.com/kikitux/curl-bash/master/vault-dev/vault.sh | sudo bash
```

vagrant
```ruby
config.vm.provision "shell", path: "https://raw.githubusercontent.com/kikitux/curl-bash/master/vault-dev/vault.sh"
```

## provision

### docker
[provision/docker](https://raw.githubusercontent.com/kikitux/curl-bash/master/provision/docker.sh)

shell
```bash
curl https://raw.githubusercontent.com/kikitux/curl-bash/master/provision/docker.sh | sudo bash
```

vagrant
```ruby
config.vm.provision "shell", path: "https://raw.githubusercontent.com/kikitux/curl-bash/master/provision/docker.sh"
```
