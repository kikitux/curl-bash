# curl-bash

A set of scripts that can be used to bootstrap dev environments in the `curl | sudo -E bash` way.

The scripts will download any file that is required, making the script portable, and to be able to use them remotely.

The scripts require `root` as we will install packages and register the services (when appropiate) with systemd.

- [consul](https://github.com/kikitux/curl-bash/blob/master/README.md#consul)
- [nomad](https://github.com/kikitux/curl-bash/blob/master/README.md#nomad)
- [vault](https://github.com/kikitux/curl-bash/blob/master/README.md#vault)
- [provision of OS tools](https://github.com/kikitux/curl-bash/blob/master/README.md#provision)

## Sample usage

For a sample vagrant project that allows customization on network IP and DC count, check [nomad-playground](https://github.com/kikitux/nomad-playground)

## General settings.

When doing more than 1 datacenter, server join server over WAN, and client join server over LAN.

```
client-dc1 -> server-dc1 <---> server-dc2 <- client-dc2
```

## consul

### consul-1server
[consul-1server/consul.sh](https://raw.githubusercontent.com/kikitux/curl-bash/master/consul-1server/consul.sh)

input:
- variable `IFACE` the interface to bind, defaults to `ens0p8`
- variable `DC` name of dc, defaults to `dc1`
- variable `WAN_JOIN` ip of first dc, defaults to `192.168.56.20`

shell
```bash
curl https://raw.githubusercontent.com/kikitux/curl-bash/master/consul-1server/consul.sh | sudo -E bash 
```

vagrant
```ruby
config.vm.define "consul" do |consul|
  consul.vm.network "forwarded_port", guest: 8500, host: 8500
  consul.vm.provision "shell",
    path: "https://raw.githubusercontent.com/kikitux/curl-bash/master/consul-1server/consul.sh"
end
```

vagrant advanced
```ruby
config.vm.define "consul" do |consul|
  consul.vm.network "forwarded_port", guest: 8500, host: 8500
  consul.vm.provision "shell", env: { "DC" => "dc2" , "WAN_JOIN" => "192.168.56.20" },
    path: "https://raw.githubusercontent.com/kikitux/curl-bash/master/consul-1server/consul.sh"
end
```


### consul-client
[consul-client/consul.sh](https://raw.githubusercontent.com/kikitux/curl-bash/master/consul-client/consul.sh)

input:
- variable `IFACE` the interface to bind, defaults to `ens0p8`
- variable `DC` name of dc, defaults to `dc1`
- variable `LAN_JOIN` ip of server, defaults to `192.168.56.20`

shell
```bash
curl https://raw.githubusercontent.com/kikitux/curl-bash/master/consul-client/consul.sh | sudo -E bash
```

vagrant
```ruby
config.vm.define "client" do |client|
  client.vm.provision "shell",
    path: "https://raw.githubusercontent.com/kikitux/curl-bash/master/consul-client/consul.sh"
end
```

vagrant advanced
```ruby
config.vm.define "client" do |client|
  client.vm.provision "shell", env: { "DC" => "dc2" , "LAN_JOIN" => "192.168.66.20" },
    path: "https://raw.githubusercontent.com/kikitux/curl-bash/master/consul-client/consul.sh"
end
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
curl https://raw.githubusercontent.com/kikitux/curl-bash/master/nomad-1server/nomad.sh | sudo -E bash 
```

vagrant
```ruby
config.vm.define "nomad" do |nomad|
  nomad.vm.network "forwarded_port", guest: 4646, host: 4646
  nomad.vm.provision "shell",
    path: "https://raw.githubusercontent.com/kikitux/curl-bash/master/nomad-1server/nomad.sh"
end
```

vagrant advanced
```ruby
config.vm.define "nomad" do |nomad|
  nomad.vm.network "forwarded_port", guest: 4646, host: 4646
  nomad.vm.provision "shell", env: { "DC" => "dc2" , "WAN_JOIN" => "192.168.56.20" },
    path: "https://raw.githubusercontent.com/kikitux/curl-bash/master/nomad-1server/nomad.sh"
end
```

### nomad-client
[nomad-client/nomad.sh](https://raw.githubusercontent.com/kikitux/curl-bash/master/nomad-client/nomad.sh)

input:
- variable `IFACE` the interface to bind, defaults to `ens0p8`
- variable `DC` name of dc, defaults to `dc1`
- variable `LAN_JOIN` ip of server, defaults to `192.168.56.20`

shell
```bash
curl https://raw.githubusercontent.com/kikitux/curl-bash/master/nomad-client/nomad.sh | sudo -E bash
```

vagrant
```ruby
config.vm.define "client" do |client|
  client.vm.provision "shell", 
    path: "https://raw.githubusercontent.com/kikitux/curl-bash/master/nomad-client/nomad.sh"
end
```

vagrant advanced
```ruby
config.vm.define "client" do |client|
  client.vm.provision "shell", env: { "DC" => "dc2" , "LAN_JOIN" => "192.168.66.20" },
    path: "https://raw.githubusercontent.com/kikitux/curl-bash/master/nomad-client/nomad.sh"
end
```

## vault

### vault-dev
[vault-dev/vault.sh](https://raw.githubusercontent.com/kikitux/curl-bash/master/vault-dev/vault.sh)

Vault root token is `changeme`

Vault requires a consul agent installed for storage backend.
Run this script after consul cluster has been created.

shell
```bash
curl https://raw.githubusercontent.com/kikitux/curl-bash/master/vault-dev/vault.sh | sudo -E bash
```

vagrant
```ruby
config.vm.define "vault" do |vault|
  vault.vm.network "forwarded_port", guest: 8200, host: 8200
  vault.vm.provision "shell", 
    path: "https://raw.githubusercontent.com/kikitux/curl-bash/master/vault-dev/vault.sh"
end
```

## provision

### add_github_user_public_keys.sh
[provision/add_github_user_public_keys.sh](https://raw.githubusercontent.com/kikitux/curl-bash/master/provision/add_github_user_public_keys.sh)

> Simple script that will download the public ssh keys of a given user, and configure the local system for ssh
password-less connection
> This script can be run as normal user or with sudo

input:
- variable `GITHUB_USER` the user which we want to download the public keys

shell
```bash
curl https://raw.githubusercontent.com/kikitux/curl-bash/master/provision/add_github_user_public_keys.sh | GITHUB_USER=my_github_user bash
```

vagrant
```ruby
config.vm.provision "shell", env: { "GITHUB_USER" => "my_github_user" },
  path: "https://raw.githubusercontent.com/kikitux/curl-bash/master/provision/add_github_user_public_keys.sh"
```

### docker
[provision/docker](https://raw.githubusercontent.com/kikitux/curl-bash/master/provision/docker.sh)

shell
```bash
curl https://raw.githubusercontent.com/kikitux/curl-bash/master/provision/docker.sh | sudo -E bash
```

vagrant
```ruby
config.vm.provision "shell",
  path: "https://raw.githubusercontent.com/kikitux/curl-bash/master/provision/docker.sh"
```

### download_product
[provision/download_product.sh](https://raw.githubusercontent.com/kikitux/curl-bash/master/provision/download_product.sh)

shell
```bash
curl https://raw.githubusercontent.com/kikitux/curl-bash/master/provision/download_product.sh | sudo -E PRODUCT=consul bash
```

advanced shell
```bash
curl -sL -o /tmp/download_product.sh https://raw.githubusercontent.com/kikitux/curl-bash/master/provision/download_product.sh
sudo -E PRODUCT=consul bash /tmp/download_product.sh
sudo -E PRODUCT=consul-template bash /tmp/download_product.sh
sudo -E PRODUCT=envconsul bash /tmp/download_product.sh
sudo -E PRODUCT=vault bash /tmp/download_product.sh
```

vagrant
```ruby
config.vm.provision "shell", env: { "PRODUCT" => "consul vault nomad" },
  path: "https://raw.githubusercontent.com/kikitux/curl-bash/master/provision/download_product.sh"
```

### grafana-server
[provision/grafana-server](https://raw.githubusercontent.com/kikitux/curl-bash/master/provision/grafana-server.sh)

> grafana uses port `3000`

shell
```bash
curl https://raw.githubusercontent.com/kikitux/curl-bash/master/provision/grafana-server.sh | sudo -E bash
```

vagrant
```ruby
config.vm.define "grafana" do |grafana|
  grafana.vm.network "forwarded_port", guest: 3000, host: 3000
  grafana.vm.provision "shell",
    path: "https://raw.githubusercontent.com/kikitux/curl-bash/master/provision/grafana-server.sh"
end
```

### node_exporter
[provision/node_exporter](https://raw.githubusercontent.com/kikitux/curl-bash/master/provision/node_exporter.sh)

> node_exporter uses port `9100`
> compatible with grafana dashboard [1860](https://grafana.com/dashboards/1860)

shell
```bash
curl https://raw.githubusercontent.com/kikitux/curl-bash/master/provision/node_exporter.sh | sudo -E bash
```

vagrant
```ruby
config.vm.provision "shell",
  path: "https://raw.githubusercontent.com/kikitux/curl-bash/master/provision/node_exporter.sh"
```

### prometheus
[provision/prometheus](https://raw.githubusercontent.com/kikitux/curl-bash/master/provision/prometheus.sh)

> install consul client for monitoring of consul metrics and nomad metrics
> prometheus uses port `9090`

shell
```bash
curl https://raw.githubusercontent.com/kikitux/curl-bash/master/provision/prometheus.sh | sudo -E bash
```

vagrant
```ruby
config.vm.define "prometheus" do |prometheus|
  prometheus.vm.network "forwarded_port", guest: 9090, host: 9090
  prometheus.vm.provision "shell",
    path: "https://raw.githubusercontent.com/kikitux/curl-bash/master/provision/prometheus.sh"
end
```

### redis-server
[provision/redis-server](https://raw.githubusercontent.com/kikitux/curl-bash/master/provision/redis-server.sh)

shell
```bash
curl https://raw.githubusercontent.com/kikitux/curl-bash/master/provision/redis-server.sh | sudo -E bash
```

vagrant
```ruby
config.vm.define "redis" do |redis|
  redis.vm.provision "shell",
    path: "https://raw.githubusercontent.com/kikitux/curl-bash/master/provision/redis-server.sh"
end
```

